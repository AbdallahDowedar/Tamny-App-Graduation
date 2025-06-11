class UserModel {
  final String id;
  final String doctorid;
  final String email;
  final String password;
  final String role;
  final String token;

  UserModel(  {
    required this.id,
    required this.doctorid,
    required this.email,
    required this.password,
    required this.role,
    required this.token,

  });

  Map<String, dynamic> toJson() {
    return {

      "id": id,
      "doctorId": doctorid,
      "email": email,
      "password": password,
      "role": role,
      "token": token,
    };
  }
}