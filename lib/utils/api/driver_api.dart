import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/driver.dart';

/// Get driver profile
Future<Driver> getDriverProfile(API api) async {
  final response = await api.get('/driver/profile');
  return Driver.fromJson(response.data);
}

/// Update driver profile
Future<void> updateDriverProfile(
  API api, {
  String? firstName,
  String? lastName,
  String? email,
  String? alternatePhone,
  String? photo,
}) async {
  await api.put('/driver/profile', data: {
    if (firstName?.isNotEmpty ?? false) 'firstName': firstName,
    if (lastName?.isNotEmpty ?? false) 'lastName': lastName,
    if (email?.isNotEmpty ?? false) 'email': email,
    if (alternatePhone?.isNotEmpty ?? false) 'alternatePhone': alternatePhone,
    if (photo?.isNotEmpty ?? false) 'photo': photo,
  });
}