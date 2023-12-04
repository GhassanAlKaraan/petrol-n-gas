class UserModel {
  String email;
  String role;
  String name; //admin, customer.

  UserModel({required this.email, required this.role, required this.name});

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
