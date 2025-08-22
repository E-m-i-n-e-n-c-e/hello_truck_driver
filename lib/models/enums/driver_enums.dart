enum VerificationStatus {
  pending('PENDING'),
  approved('VERIFIED'),
  rejected('REJECTED');

  const VerificationStatus(this.value);
  final String value;

  static VerificationStatus fromString(String value) {
    return VerificationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => VerificationStatus.pending,
    );
  }
}

enum DriverStatus {
  available('AVAILABLE'),
  online('ONLINE'),
  offline('OFFLINE'),
  onRide('ON_RIDE');

  const DriverStatus(this.value);
  final String value;

  static DriverStatus fromString(String value) {
    return DriverStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => DriverStatus.available,
    );
  }

}