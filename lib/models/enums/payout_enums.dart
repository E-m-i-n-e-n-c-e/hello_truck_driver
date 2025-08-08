enum PayoutMethod {
  bankAccount('BANK_ACCOUNT'),
  vpa('VPA');

  const PayoutMethod(this.value);
  final String value;
}