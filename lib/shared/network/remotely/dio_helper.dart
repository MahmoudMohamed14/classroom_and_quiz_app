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
  static Future<Response> postNotification({
  required String to,
    required String title,
    required String body,
    Map<String,dynamic>?data

}) async{
    return await dio.post('fcm/send',
      data: {
        "to": to,
        "notification": {
          "title": title,
          "body": body,
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
        "data": data
      }
    );
  }
}