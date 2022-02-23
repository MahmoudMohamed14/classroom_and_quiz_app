class QuizModel {
  String?title;
  String?date;
  String?time;
  bool ?quizDone ;

  Map<String, dynamic> ?questionMap;


  QuizModel({this.title, this.date, this.time, this.quizDone=false, this.questionMap});
  QuizModel.fromJson({required Map<String,dynamic> json,}){

    title=json['title'];
    date=json['date'];
    time=json['time'];
   quizDone=json['quizDone'];
   questionMap=json['questionMap'];


  }
  Map<String,dynamic>toMap() {
    return {
      'title': title,

      'date': date,
      'time': time,
      'quizDone': quizDone,
      'questionMap': questionMap,


    };
  }
}