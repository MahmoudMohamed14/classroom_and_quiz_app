// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:quizapp/moduls/login/login_screen.dart';

import 'package:quizapp/shared/componant/componant.dart';

class GetStart extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height:200 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  image: DecorationImage(
                    image: AssetImage('assets/image/image_login.jpg'),
                    fit: BoxFit.cover
                ),
              ),
              ),
              SizedBox(
                height: 100,
              ),
              defaultButton(onPress: (){
                navigateTo(context, LoginScreen());

              }, name: 'student'),
              SizedBox(
                height: 20,
              ),
              defaultButton(onPress: (){

              }, name: 'teacher'),

            ],
          ),
        ),
      ),

    );
  }
}
