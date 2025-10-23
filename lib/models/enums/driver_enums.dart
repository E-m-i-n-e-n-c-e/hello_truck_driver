enum VerificationStatus {
  pending('PENDING'),
  verified('VERIFIED'),
  rejected('REJECTED');

  const VerificationStatus(this.value);
  final String value;

  static VerificationStatus fromString(String value) {
    return VerificationStatus.values.firstWhere(
      (status) => status.value == value,
    );
  }
}

enum DriverStatus {
  available('AVAILABLE'),
  unavailable('UNAVAILABLE'),
  onRide('ON_RIDE'),
  rideOffered('RIDE_OFFERED');

  const DriverStatus(this.value);
  final String value;

  static DriverStatus fromString(String value) {
    return DriverStatus.values.firstWhere(
      (status) => status.value == value,
    );
  }

}