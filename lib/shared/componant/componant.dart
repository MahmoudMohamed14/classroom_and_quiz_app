import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';

void subscribeToTopic({required String topicName}){
    FirebaseMessaging.instance.subscribeToTopic(topicName).then((value) {
      print('subscribeFromTopic success');
    }).catchError((onError){
      print(onError.toString());
    });
}
void unSubscribeToTopic({required String topicName}){
   FirebaseMessaging.instance.unsubscribeFromTopic(topicName).then((value) {
     print('unsubscribeFromTopic success');
   }).catchError((onError){
     print(onError.toString());
   });
}
Widget defaultButton(
    {
      required Function onPress,
      required String name,
      double width=double.infinity,
      Color color=mainColor



    }
    )=>Container(
  decoration:BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: color

  ) ,


  height: 50,
  width:width ,
  child: MaterialButton(


    onPressed: () {
      onPress();

    },
    child: Text(
      name.toUpperCase(),
      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),
    ),),
);
Widget defaultEditText(
    {
      required TextEditingController   control,
      required String label,
      IconData? prefIcon,
      Function ?onPressSuffix,
      Function()?onPress,
      IconData? sufIcon,

      required FormFieldValidator validat,
      bool enable=false,
      bool enableText=true,
      TextInputType ?textType
    }
    )
{

  return TextFormField(

    validator: validat,
    obscureText: enable,
    controller: control,
    keyboardType:textType ,
    autocorrect: false,
    cursorColor: mainColor,
    decoration:InputDecoration(

        errorStyle: TextStyle(color: Colors.red),

        enabledBorder: OutlineInputBorder(


            borderSide: BorderSide(color: mainColor),

            borderRadius:BorderRadius.circular(10)),
        focusedBorder:OutlineInputBorder(


            borderSide: BorderSide(color: mainColor),

            borderRadius:BorderRadius.circular(10)) ,

        errorBorder:OutlineInputBorder(


            borderSide: BorderSide(color: Colors.red),

            borderRadius:BorderRadius.circular(10)) ,
        focusedErrorBorder: OutlineInputBorder(


            borderSide: BorderSide(color: Colors.red),

            borderRadius:BorderRadius.circular(10)),

        labelStyle: TextStyle(color: mainColor),
        labelText: label,
        prefixIcon: Icon(prefIcon),

        suffixIcon: IconButton(onPressed:(){
          onPressSuffix!();
        }
          ,icon: Icon(sufIcon),
        )


    ) ,
    onTap: (){

      if(onPress!=null){
        onPress();
      }

    },
    enabled: enableText,




  );

}
Widget defaultTextButton(
    {
      required
      Function
      onPress
      ,
      required
      String
      name
      ,
    })=> TextButton(child: Text(name.toUpperCase()),onPressed: (){onPress();},);
void navigateTo(context,widget ){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
}
void navigateAndFinish(context,widget ){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget),(route)=>false);
}
enum ToastState{SUCCESS,ERROR,WARNING}
 void showToast({ required String text,required ToastState state}){
   Fluttertoast.showToast(
       msg: text,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: toastColor(state: state),
       textColor: Colors.white,
       fontSize: 16.0
   );


}
Color toastColor({
  required ToastState state
}){
 late Color color;
  switch(state){
    case ToastState.SUCCESS:
      color= Colors.green;
      break;
    case ToastState.ERROR:
      color= Colors.red;
      break;
    case ToastState.WARNING:
      color= Colors.yellow;
      break;

  }
  return color;
}
  void signOut( context,widget) {


   FirebaseAuth.instance.signOut().then((value) {
     CacheHelper.removeWithKey(key: 'email');
     navigateAndFinish(context, widget);
   });



}
