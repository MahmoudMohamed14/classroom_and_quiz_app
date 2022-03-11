class QuestionModel{
  String ?question;
  String ?optoin1;
  String ?optoin2;
  String ?optoin3;
  String ?optoin4;


  QuestionModel({this.question, this.optoin1, this.optoin2, this.optoin3, this.optoin4});
  QuestionModel.fromJson({required Map<String,dynamic> json}){
    question=json['question'];
    optoin1=json['option1'];
    optoin2=json['option2'];
    optoin3=json['option3'];
    optoin4=json['option4'];
  }
  Map<String,dynamic>toMap() {
    return {
      'question': question,

      'option1': optoin1,
      'option2': optoin2,
      'option3': optoin3,
      'option4': optoin4,


    };
  }

}