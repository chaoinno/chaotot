class UserModel {
  // Field
  String id, name, user, password, avatar;

  // Constructor
  UserModel(this.avatar, this.id, this.name, this.password, this.user);

  UserModel.fromJSON(Map<String, dynamic> map){
    id = map['id'];
    name = map['Name'];
    user = map['User'];
    password = map['Password'];
    avatar = map['Avatar'];
  }
}