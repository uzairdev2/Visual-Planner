class Users {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  Users({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
