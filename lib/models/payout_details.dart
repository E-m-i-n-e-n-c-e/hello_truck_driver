import 'enums/payout_enums.dart';

class BankDetails {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;

  const BankDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
  });

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'accountNumber': accountNumber,
    'ifscCode': ifscCode,
  };
}

class VpaDetails {
  final String vpa;

  const VpaDetails({required this.vpa});

  Map<String, dynamic> toJson() => {
    'vpa': vpa,
  };
}

class PayoutDetails {
  final PayoutMethod payoutMethod;
  final BankDetails? bankDetails;
  final VpaDetails? vpaDetails;

  const PayoutDetails({
    required this.payoutMethod,
    this.bankDetails,
    this.vpaDetails,
  });

  Map<String, dynamic> toJson() => {
    'payoutMethod': payoutMethod.value,
    if (bankDetails != null) 'bankDetails': bankDetails!.toJson(),
    if (vpaDetails != null) 'vpaDetails': vpaDetails!.toJson(),
  };
}