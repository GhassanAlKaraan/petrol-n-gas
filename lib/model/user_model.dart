class UserModel {
  String email;
  String role; //admin, user

  UserModel({required this.email,required this.role});



  //toMap
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }

}
