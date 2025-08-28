import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/services/web_socket_service.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});





