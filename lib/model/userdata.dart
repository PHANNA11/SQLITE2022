class User {
  late int id;
  late String name;
  late String password;
  User({required this.id, required this.name, required this.password});
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

  User.toJson(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        password = res["password"];
}
