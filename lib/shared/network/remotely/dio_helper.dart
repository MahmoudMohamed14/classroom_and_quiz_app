import 'package:dio/dio.dart';


class DioHelper{
  static late Dio dio;
  static  init(){
    dio=Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://fcm.googleapis.com/',
        headers: {
          'Content-Type':'application/json',
          'Authorization':'key=AAAAQUO8qo8:APA91bE3w1AOkw2kMA8rQo-UPfIXR-fbhpC63v_c6uQh1kQJLXOOiWWTx59ilM3D8otmYxBGFSzpKEoJKFVr8-TDO6VIgwn-xzeOjldyZHq6nEBeULXAU-M0CC8m1H9nAlM4Jh7hS1P1'
        }
      )
    );
  }
  static Future<Response> postNotification() async{
    return await dio.post('fcm/send',
      data: {
        "to": 'd5Xbz0YoRnq6p-7iRAO__q:APA91bE7mSZCAYb8dIZ_u1-6xsVGjsqXdIvUlfg7QeaAcLeJ8H64YcdshOj8MY8I-hLwr57zE-RgY20ryyt3uRYYV6cBGD40b3_1kPNd7_vDxKKpr0lF7HRaLOp4ZoeH2bbeZBD-66PE',
        "notification": {
          "title": "message from mahmoud",
          "body": "testing body from post man",
          "sound": "default",


        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",

            "sound": "default",
            "default_sound": true,
            "default_vibrate_timings": true,
            "default_light_settings": true
          }
        },
        "data": {

          "test": "test"

        }
      }
    );
  }
}