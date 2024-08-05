class PasswordModel {
  final int id;
  final String password;

  PasswordModel({
    required this.id,
    required this.password,
  });

  // Convert a PasswordModel into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
    };
  }
}
