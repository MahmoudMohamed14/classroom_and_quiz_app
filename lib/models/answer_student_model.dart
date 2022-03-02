class AnswerStudentModel{
  String? name;
  String? email;
  String? myAnswer;
  bool?isDone;

  AnswerStudentModel({this.name, this.email, this.myAnswer, this.isDone=true});
  AnswerStudentModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    email=json['email'];
    myAnswer=json['myAnswer'];
    isDone=json['isDone'];


  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'myAnswer':myAnswer,
      'isDone':isDone,

    };
  }
}