class User {
  late int id;
  late String name;
  late String password;
  //late String pic;
  User({
    required this.id,
    required this.name,
    required this.password,
    // required this.pic
  });
  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      // 'pic': pic,
    };
  }

  User.toJson(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        password = res["password"];
  //  pic = res["pic"];
}
