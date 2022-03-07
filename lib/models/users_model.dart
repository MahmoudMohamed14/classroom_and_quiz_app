

class UsersModel{
  String? name;
  String? email;
  String ?token;

  String? id;
  String? password;

  bool ?isTeacher;

  UsersModel({this.name, this.email,this.id, this.password,this.isTeacher,this.token});
  UsersModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    email=json['email'];
    password=json['password'];
   id=json['id'];
   isTeacher=json['isTeacher'];
   token=json['token'];


  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'password':password,
      'id':id,
      'isTeacher':isTeacher,
      'token':token

    };
  }
}