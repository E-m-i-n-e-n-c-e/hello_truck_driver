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