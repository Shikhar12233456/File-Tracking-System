class User {
  String username;
  String firstname;
  String secondname;
  String email;
  String bio;
  User(
      {required this.username,
      required this.firstname,
      required this.secondname,
      required this.email,
      required this.bio});

  Map<String, dynamic> tomap() {
    return {
      'username': username,
      'firstname': firstname,
      'secondname': secondname,
      'email': email,
      'bio': bio
    };
  }

  User fromMap(Map<dynamic, String> map) {
    return User(
        username: map['username'] ?? " ",
        firstname: map['firstname'] ?? " ",
        secondname: map['secondname'] ?? " ",
        email: map['email'] ?? " ",
        bio: map['bio'] ?? " ");
  }
}
