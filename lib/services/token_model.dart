import 'package:cloud_firestore/cloud_firestore.dart';

class TokenModel{
  String? token;
  FieldValue? creditAt;

  TokenModel({required this.token, required this.creditAt});

   TokenModel.fromData(Map<String, dynamic> data)
       : token = data['token'],
       creditAt = data['CreditAt'];

  static TokenModel? fromMap(Map<String, dynamic> map){
    if(map == null) {
      return null;
    }
    return TokenModel(
      token: map['id'],
      creditAt: map['username'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'id': token,
      'username': creditAt,
    };
  }
}