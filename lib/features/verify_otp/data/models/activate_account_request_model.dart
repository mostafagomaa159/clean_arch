class ActivateAccountRequest {
  final int customerId;

  const ActivateAccountRequest({
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'isVerified': 'true',
      'customerId': customerId.toString(),
    };
  }
}
