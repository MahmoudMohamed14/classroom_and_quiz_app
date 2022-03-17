


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:quizapp/bloc_observer.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/moduls/classrooms/classrooms.dart';
import 'package:quizapp/moduls/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {


    await Firebase.initializeApp();
    print(message.data);
    print(message.notification!.title);
    if(message.notification!.title=='Add to Class'){
      print(message.data['addToClaas']);
     return subscribeToTopic(topicName: message.data['className']);

    } if(message.notification!.title== 'your teacher  delete you'){
      print(message.data['deleteClass']);
     return unSubscribeToTopic(topicName: message.data['className']);
    }





}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheHelper.init();
  String? lang;
  if(CacheHelper.getData(key: 'lang')!=null) {
    lang =CacheHelper.getData(key: 'lang');
  }else{
    lang='en';
  }

  var token= await FirebaseMessaging.instance.getToken();
  print('token= '+token.toString());

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

print(message.data);
    if(message.notification!.title=='Add to Class'){
      print(message.data['addToClaas']);
   return subscribeToTopic(topicName: message.data['className']);
      
    } if(message.notification!.title== 'your teacher  delete you'){
      print(message.data['deleteClass']);
    return unSubscribeToTopic(topicName: message.data['className']);
    }

  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if(CacheHelper.getData(key: 'email')!=null) {
    myEmail = CacheHelper.getData(key: 'email');
  }
  DioHelper.init();


  BlocOverrides.runZoned(
        () {
          runApp(
             MyApp(lang: lang,),);
    },
    blocObserver: MyBlocObserver(),
  );



}

class MyApp extends StatelessWidget {
  String?lang;
  MyApp({this.lang});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return

         MultiBlocProvider(
           providers: [
             BlocProvider(create: (BuildContext context)=>CubitApp()..getClassName()..getCurrentUser()..getMyAllClassRoom()..getAllUser()..changeLang(fromCache: lang),),
             BlocProvider<CubitLayout>(create: (context)=>CubitLayout()),
           ],
           child: BlocConsumer<CubitApp,StateApp>(
             listener:(context,state){} ,
             builder: (context,state){
               return  MaterialApp(
                 debugShowCheckedModeBanner: false,

                 theme: ThemeData(
                   scaffoldBackgroundColor: Colors.white,
                   primaryColor: mainColor,
                   primaryColorLight: mainColor,
                   primaryColorDark: mainColor,
                   colorScheme: ColorScheme.fromSwatch().copyWith(
                       primary: mainColor,
                       secondary: mainColor
                   ),
                   textTheme: const TextTheme(
                     bodyText1: TextStyle(
                       color: Colors.black,fontSize: 18,
                     ),
                     headline1: TextStyle(
                         color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
                     ),

                   ),
                   appBarTheme: const  AppBarTheme(

                     // backwardsCompatibility: false,
                     actionsIconTheme: IconThemeData(
                         color: Colors.black
                     ),

                     iconTheme: IconThemeData(
                         color: Colors.black
                     ),
                     titleTextStyle: TextStyle(color: Colors.black),
                     systemOverlayStyle: SystemUiOverlayStyle(
                         statusBarColor: Colors.white,
                         statusBarIconBrightness: Brightness.dark
                     ),
                     backgroundColor: Colors.white,
                     elevation: 0,

                   ),
                 ),
                 supportedLocales:const [
                   Locale('en',),
                   Locale('ar'),
                 ],
                 locale: Locale(CubitApp.get(context).lang) ,

                 localizationsDelegates: const[
                   AppLocale.delegate,
                 GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                   GlobalCupertinoLocalizations.delegate,

                 ],
                 localeResolutionCallback: (currentLang,supportedLang){
                   if(currentLang!=null){
                     for(Locale local in supportedLang){
                       if(local.languageCode==currentLang.languageCode){
                         return currentLang;
                       }
                     }

                   }
                   return supportedLang.first;
                 },
                 home:firstScreen(iscurrentuser:FirebaseAuth.instance.currentUser!=null,context: context ),
               );
             },

           ),
         );


  }
  Widget firstScreen({bool? iscurrentuser, context}){


    Widget launch=LoginScreen();
    if(iscurrentuser!){
      launch= ClassScreen();
    }else {
      launch=LoginScreen();
    }
    return launch;
  }


}


