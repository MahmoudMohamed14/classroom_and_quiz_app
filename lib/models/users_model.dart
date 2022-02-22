

class UsersModel{
  String? name;
  String? email;

  String? id;
  String? password;

  bool ?isTeacher;

  UsersModel({this.name, this.email,this.id, this.password,this.isTeacher});
  UsersModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    email=json['email'];
    password=json['password'];
   id=json['id'];
   isTeacher=json['isTeacher'];


  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'password':password,
      'id':id,
      'isTeacher':isTeacher

    };
  }
}