import 'dart:async';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class WebSocketService {
  static WebSocketService? _instance;

  factory WebSocketService(API api) {
    _instance = WebSocketService._(api);
    return _instance!;
  }

  WebSocketService._(this._api);

  final API? _api;
  late io.Socket _socket;
  bool _isConnected = false;

  // Map to store listeners for different channels
  final Map<String, List<Function(dynamic)>> _listeners = {};

  Future<void> connect() async {
    _socket = io.io('$baseUrl/driver', {
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
    });
    print('🔌 Socket connecting');
    _socket.auth = {'token': _api?.accessToken};
    print('🔌 Socket auth: ${_socket.auth}');
    _socket.connect();

    _socket.onConnect((_) {
      print('🔌 Socket connected');
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('🔌 Socket disconnected');
      _isConnected = false;
    });

    _socket.onReconnect((_) {
      print('🔌 Socket reconnected');
      _isConnected = true;
    });

    _socket.onReconnectAttempt((_) async {
      print('🔌 Socket reconnecting');
      _socket.auth = {'token': _api?.accessToken};
    });
  }

  void sendMessage(String channel, dynamic data) {
    if (_isConnected) {
      _socket.emit(channel, data);
      print('📤 Sent to $channel: $data');
    } else {
      print('⚠️ WebSocket not connected, message not sent: $channel');
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
    _listeners.clear();
    _socket.dispose();
  }
}



