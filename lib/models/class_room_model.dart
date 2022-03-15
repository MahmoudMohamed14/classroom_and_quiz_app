 class ClassRoom{
  String ? className;
  String ? subject;
  String ? teacherName;
  String ? teacherEmail;
  String ? code;
  ClassRoom({ required this.className,required this.subject,required this.teacherEmail,required this.teacherName,this.code});

  ClassRoom.fromJson({required Map<String,dynamic> json}){
    className=json['className'];
    subject=json['subject'];
    teacherName=json['teacherName'];
    teacherEmail=json['teacherEmail'];
   code=json['code'];


  }

  Map<String,dynamic> toMap(){
    return{
      'className':className,
      'subject':subject,
      'teacherName':teacherName,
      'teacherEmail':teacherEmail,
      'code':code,

    };
  }
 }