
class User {
  final String uid;
  final String name;
  final String email;
  final String proPicUrl;

  User( {
    required this.uid,
    required this.name,
    required this.email,
    required this.proPicUrl,
  });


  toJson()=>{
    'uid':uid,
    'displayName':name,
    'email':email,
    'proPic':proPicUrl,
  };


  factory User.fromMap (dynamic map){

    return User(
      uid:map['uid'],
      name:map['displayName']??'',
      email:map['email']??'',
      proPicUrl: map['proPic']??'',
    );  
  }

}