// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';

import 'package:quizapp/moduls/classrooms/classrooms.dart';
import 'package:quizapp/moduls/register/cubit/register_cubit.dart';
import 'package:quizapp/moduls/register/cubit/register_state.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class Register extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var email=TextEditingController();
    var name=TextEditingController();
    var className=TextEditingController();
    var password=TextEditingController();
    var keyForm= GlobalKey<FormState>();






    return BlocProvider(
        create: (context)=>RegisterCubit(),
        child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state){
      if(state is CreateUserSuccessState||state is PostClassNameSuccessState){
        navigateAndFinish(context, ClassScreen());
        CubitApp.get(context).init();
        showToast(text: 'Create Successful', state: ToastState.SUCCESS);

      }  if (state is CreateUserErrorState)
      {


        showToast(text:state.error! , state: ToastState.ERROR);
      }
      if (state is RegisterErrorState)
      {
        showToast(text:state.error! , state: ToastState.ERROR);
      }if (state is PostClassNameErrorState)
      {
        showToast(text:state.error! , state: ToastState.ERROR);
      }


    },
    builder:(context,state){
    var cubit=RegisterCubit.get(context);
      isTeacher = cubit.isTeacher;
     return  Scaffold(
       appBar: AppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keyForm,
            child: Column(
              children:  [
                Text('Register',style:Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),),
                SizedBox(height: 20,),
                defaultEditText(
                    control: name,
                    textType: TextInputType.name,
                    prefIcon: Icons.title,
                    label: 'full name',
                    validat: (s){
                      if(s!.isEmpty){
                        return'name is empty';
                      }
                      return null;

                    }
                ),
                SizedBox(height: 20,),
                defaultEditText(
                    control: email,
                    textType: TextInputType.emailAddress,
                    prefIcon: Icons.email,
                    label: 'email',
                    validat: (s){
                      if(s!.isEmpty){
                        return'email is empty';
                      }
                      return null;

                    }
                ),
                // SizedBox(height: 20,),
                //   ConditionalBuilder(
                //     condition: !constIsTeacher!,
                //     builder:(context)=> defaultEditText(
                //        control: className,
                //        textType: TextInputType.text,
                //        prefIcon: Icons.group,
                //        label: 'class name',
                //        validat: (s){
                //          if(s!.isEmpty){
                //            return'class name is empty';
                //          }else if( constIsTeacher!&& listClassName .isNotEmpty){
                //
                //            for(int i=0;i<listClassName.length;i++){
                //              if(s == listClassName[i]){
                //                isexist=true;
                //              }
                //
                //            }
                //            return isexist?'already exist try anther classNme ':null;
                //
                //
                //
                //          }else if(constIsTeacher==false ){
                //           int counter=0;
                //
                //            for(int i=0;i<listClassName.length;i++){
                //              if(s.toString().trim()== listClassName[i].trim() ){
                //                counter=1;
                //              }
                //
                //
                //            }
                //            return counter==1?null:'not exist ';
                //
                //
                //
                //          }
                //          return null;
                //
                //        }
                //  ),
                //     fallback:(context)=> SizedBox(width: 1,),
                //   ),
                SizedBox(height: 20,),

                defaultEditText(
                    control: password,
                    textType: TextInputType.text,
                    prefIcon: Icons.lock,
                    label: 'password',
                    validat: (dynamic s){
                      if(s!.isEmpty){
                        return'password is empty';
                      }else if(s.toString().length<8){
                        return 'must length greater than 8 char';
                      }


                      return null;

                    }
                ),
                SizedBox(height: 20,),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: mainColor)

                  ),
                  child: DropdownButton(

                      isExpanded: true,
                      iconSize: 40,

                      value:  RegisterCubit.get(context).isTeacher,


                      onChanged: ( value){
                        RegisterCubit.get(context).radioButton(teacher: value);

                      },

                      items:const[
                        DropdownMenuItem<bool>(child: Text('Teacher',),value: true,),
                        DropdownMenuItem<bool>(child: Text('Student '),value: false,),
                      ]
                  ),
                ),
                SizedBox(height: 20,),

               state is RegisterLoadingState? CircularProgressIndicator()
                    :defaultButton(onPress: (){


                      if(keyForm.currentState!.validate()){
                 if(isTeacher==null){
                showToast(text: 'you must choose teacher or student', state: ToastState.WARNING);

             }else {
           cubit.registerUser(name: name.text, email: email.text, password: password.text,isTeacher: cubit.isTeacher!);
         }
                      }else{

                      }

                    }, name: 'Register'),







              ],

            ),
          ),
        ),
      ),
            );}

        ),
    );
  }
}
