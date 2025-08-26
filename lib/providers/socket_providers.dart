import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/services/web_socket_service.dart';

final socketServiceProvider = FutureProvider<WebSocketService>((ref) async {
  final api = await ref.watch(apiProvider.future);
  final service = WebSocketService(api);
  service.connect();
  return service;
});





