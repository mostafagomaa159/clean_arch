class CustomerModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final Map<String, String> customAttributes;

  const CustomerModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.customAttributes,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final attributes = <String, String>{};
    final rawAttributes = json['custom_attributes'];

    if (rawAttributes is List) {
      for (final item in rawAttributes) {
        if (item is Map && item['attribute_code'] != null) {
          attributes[item['attribute_code'].toString()] =
              item['value']?.toString() ?? '';
        }
      }
    }

    return CustomerModel(
      id: int.parse(json['id'].toString()),
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      customAttributes: attributes,
    );
  }
}

class AuthResponse {
  final String token;
  final String? cartId;
  final CustomerModel customer;
  final String? activationCode;
  final String? mobileNumber;
  final String? verificationStatus;

  const AuthResponse({
    required this.token,
    required this.cartId,
    required this.customer,
    required this.activationCode,
    required this.mobileNumber,
    required this.verificationStatus,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token']?.toString() ?? '',
      cartId: json['cart_id']?.toString(),
      customer: CustomerModel.fromJson(
        Map<String, dynamic>.from(json['customer'] as Map),
      ),
      activationCode: json['activation_code']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      verificationStatus: json['verification_status']?.toString(),
    );
  }
}
