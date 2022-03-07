class StudentModel {
  String ?studentName;
  String?studentEmail;


  StudentModel({this.studentName, this.studentEmail,});
  StudentModel.fromJson({required Map<String,dynamic> json}){
    studentName=json['studentName'];

    studentEmail=json['studentEmail'];


  }
  Map<String,dynamic>toMap(){
    return{
      'studentName':studentName,

      'studentEmail':studentEmail,


    };
  }
}