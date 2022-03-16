class ChatModel{
  String? sendEmail;
  String? receiverEmail;
  String? dateTime;
  String? text;

  ChatModel({this.sendEmail, this.receiverEmail, this.dateTime, this.text});
  ChatModel.fromJson(Map<String,dynamic> json){
    sendEmail=json['sendId'];
    text=json['text'];

    receiverEmail=json['receiverEmail'];

    dateTime=json['dateTime'];

  }
  Map<String,dynamic>toMap(){
    return{
      'receiverEmail':receiverEmail,
      'dateTime':dateTime,
      'text':text,
      'sendEmail':sendEmail,
    };
  }
}