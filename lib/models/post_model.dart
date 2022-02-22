class PostModel{
  String ?name;
  String ?date;
  String ?text;
  String ?email;

  PostModel({this.name, this.date, this.text, this.email});
  PostModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    date=json['date'];
    text=json['text'];
     email=json['email'];

  }
  Map<String,dynamic>toMap(){
    return{
      'name':name,
      'date':date,
      'text':text,
      'email':email,


    };
  }
}