class RegisterRequest {
  final String mobile;
  final String password;

  const RegisterRequest({
    required this.mobile,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'password': password,
    };
  }
}
