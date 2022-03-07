// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';

import 'package:quizapp/moduls/classrooms/classrooms.dart';


import 'package:quizapp/moduls/login/cubit/login_cubit.dart';
import 'package:quizapp/moduls/login/cubit/login_state.dart';

import 'package:quizapp/moduls/register/register.dart';



import 'package:quizapp/shared/componant/componant.dart';


class LoginScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    TextEditingController? email= new TextEditingController();
    TextEditingController? password=new TextEditingController();
    var keyForm=GlobalKey<FormState>();




    return 
      BlocProvider(
        create: (BuildContext context)=>LoginCubit(),

        child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context,state){
            if(state is LoginSuccessState){

              navigateAndFinish(context, ClassScreen());
              CubitApp.get(context).init();




            }
            if(state is LoginErrorState)
            {
              showToast( state: ToastState.ERROR, text: state.error!);
            }



          },
          builder: (context,state){

            var cubit=LoginCubit.get(context);
            return Scaffold(

                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LOGIN',
                              style:Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10,),
                            // Text('login now to ', style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54,fontSize: 18),),
                            SizedBox(height: 30,),
                            defaultEditText(
                                control: email,
                                validat: ( s){
                                  if(s!.isEmpty){
                                    return'Email is Empty';
                                  }
                                  return null;
                                },
                                label: 'Email',
                                prefIcon: Icons.email_outlined,
                                textType: TextInputType.emailAddress
                            ),
                            SizedBox(height: 20,),
                            defaultEditText(control: password,
                                validat: ( s){
                                  if(s.isEmpty){
                                    return'password is Empty';
                                  }
                                  return null;
                                },
                                textType:TextInputType.visiblePassword,
                                enable: cubit.isScure,
                                sufIcon: cubit.suffix,
                                label: 'Password',

                                prefIcon: Icons.lock,
                                onPressSuffix: (){
                              cubit.passwordLogin();

                                }
                            ),
                            SizedBox(height: 30,),
                         state is LoginLoadingState?Center(child: CircularProgressIndicator()) : defaultButton(
                                onPress: (){
                                  if(keyForm.currentState!.validate()){

                                      cubit.login(password: password.text, email: email.text);



                                      //here you code


                                  }else{
                                  }
                                },
                                name: 'LOGIN'),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have account?'),
                                defaultTextButton(onPress: (){

                                  //  cubit.getClassName();
                                    navigateTo(context, Register());




                                }, name: 'Register')
                              ],),



                          ],),
                      ),
                    ),
                  ),
                ),
            );

          },

        ),
      );


  }
}
