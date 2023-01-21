class UserModel{
  String? id;
  String? username;
  String? email;

  UserModel({this.id, this.username, this.email});
  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        username = data['username'],
        email = data['email'];
  static UserModel? fromMap(Map<String, dynamic> map){
    if(map.isEmpty) {
      return null;
    }
    return UserModel(
        id: map['id'],
        username: map['username'],
        email: map['email'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}