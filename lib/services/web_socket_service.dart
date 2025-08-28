import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/utils/constants.dart';
import 'package:hello_truck_driver/utils/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static SocketService? _instance;
  factory SocketService() => _instance ??= SocketService._();
  SocketService._();

  final secureStorage = FlutterSecureStorage();
  late API _api;
  late io.Socket _socket;
  bool _isConnected = false;

  Future<String?> readAccessToken() async {
    return await secureStorage.read(key: 'accessToken');
  }

  // Map to store listeners for different channels
  final Map<String, List<Function(dynamic)>> _listeners = {};

  Future<void> connect(API api) async {
    if (_isConnected) return;
    _api = api;
    _socket = io.io('$baseUrl/driver', {
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
    });
    AppLogger.log('🔌 Socket connecting');
    _socket.auth = {'token': _api.accessToken ?? await readAccessToken()};
    AppLogger.log('🔌 Socket auth: ${_socket.auth}');
    _socket.connect();

    _socket.onConnect((_) {
      AppLogger.log('🔌 Socket connected');
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      AppLogger.log('🔌 Socket disconnected');
      _isConnected = false;
    });

    _socket.onReconnect((_) {
      AppLogger.log('🔌 Socket reconnected');
      _isConnected = true;
    });

    _socket.onReconnectAttempt((_) async {
      AppLogger.log('🔌 Socket reconnecting');
      _socket.auth = {'token': _api.accessToken ?? await readAccessToken()};
    });
  }

  void sendMessage(String channel, dynamic data) {
    if (_isConnected) {
      _socket.emit(channel, data);
      AppLogger.log('📤 Sent to $channel: $data');
    } else {
      AppLogger.log('⚠️ WebSocket not connected, message not sent: $channel');
    }
  }

  void addListener(String channel, Function(dynamic) handler) {
    if (!_listeners.containsKey(channel)) {
      _listeners[channel] = [];
      _socket.on(channel, (data) {
        _notifyListeners(channel, data);
      });
    }
    _listeners[channel]!.add(handler);
  }

  void removeListener(String channel, Function(dynamic) handler) {
    _listeners[channel]?.remove(handler);
  }

  void _notifyListeners(String channel, dynamic data) {
    final channelListeners = _listeners[channel];

    if (channelListeners != null) {
      for (final handler in channelListeners) {
        handler(data);
      }
    }
  }


  void dispose() {
    _isConnected = false;
    _listeners.clear();
    _socket.dispose();
  }
}



