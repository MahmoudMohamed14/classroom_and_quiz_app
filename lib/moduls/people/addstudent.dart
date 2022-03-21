import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class AddStudent extends StatelessWidget {

 TextEditingController control= TextEditingController();
 var token;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp,StateApp>(
      listener: (context,state){
        if(state is AddStudentToClassSuccessState){
          showToast(text: 'Add Successfully', state: ToastState.SUCCESS);


          CubitLayout.get(context).getAllStudent();

          control.clear();
          Navigator.pop(context);
        }else if(state is AddStudentToClassErrorState){
          showToast(text: state.error.toString(), state: ToastState.ERROR);
        }
      },
      builder:(context,state){
        return Scaffold(
          appBar: AppBar(
            title:Text('${getLang(context, "add_student")}',style: Theme.of(context).textTheme.headline1,),
            actions: [
              TextButton(onPressed: (){
                print('hi mahmoud');
                CubitApp.get(context).allUser.forEach((element) {
                  if(control.text==element.email){
                    print('yes success + ${element.isTeacher}+ ${element.password}');
                     token=element.token;
                    CubitApp.get(context).addClassRoomToTeacherAndCurrentUser
                      (
                        CubitLayout.get(context).classRoomModel!.toMap(),
                        studentEmail: element.email,
                        studentName: element.name,
                        isteacher: true

                    );
                    DioHelper.postNotification(to: token,
                        title: 'Add to Class',
                        body: ' your teacher ${globalUserModel!.name} add you in  class',
                        data: {'payload':'sub${CubitLayout.get(context).classRoomModel!.code}','className':CubitLayout.get(context).classRoomModel!.className,
                          'type': 'order',
                          'id': '87',
                          'deleteClass':'false',
                          'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
                    );

                  }


                });



              }, child: Text('${getLang(context, "add")}'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                state is AddStudentToClassLoadingState?LinearProgressIndicator():SizedBox(),
                SizedBox(height: 20),
                defaultEditText(control: control, label: '${getLang(context, "email_name")}', validat: (s){
                  if(s!.isEmpty){
                    return'${getLang(context, "email_empty")}';
                  }
                  return null;
                })
              ],

            ),
          ),

        );
      } ,

    );
  }
}
