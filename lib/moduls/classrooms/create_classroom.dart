
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class CreateClassScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var classNameController = TextEditingController();
  var subjectController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
      listener: (context, state)
      {
        if (state is SuccessCreateClassState) {
          Navigator.pop(context);
          showToast(
              text: 'Class Created Successfully', state: ToastState.SUCCESS);
        }

        else if (state is GetClassSuccessState) {
          Navigator.pop(context);
        }
        else if (state is AddStudentToClassSuccessState) {
          showToast(text: 'Add Student To Class Successfully', state: ToastState.SUCCESS);
        }
        else if (state is AddStudentToClassErrorState) {
          showToast(text: state.error!, state: ToastState.ERROR);
        }
        else if (state is GetClassErrorState) {
          showToast(text: state.error!, state: ToastState.ERROR);
        }
        else if (state is ErrorAddClassToTeacherState) {
          showToast(text: state.error!, state: ToastState.ERROR);
        }
        else if (state is ErrorCreateClassState) {
          showToast(text: state.error!, state: ToastState.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = CubitApp.get(context);
        return Scaffold(

          appBar: AppBar(

            actions: [
              TextButton(onPressed: () {
                if(formKey.currentState!.validate()){
                  if(cubit.currentUser.isTeacher!) {
                    String code=cubit.getRandomString(8).toLowerCase();
                    cubit.createClass(classRoom: ClassRoom(className:
                    classNameController.text,
                      subject: subjectController.text,
                      teacherEmail: cubit.currentUser.email,
                      teacherName: cubit.currentUser.name,code: code));

                  }else{
                    cubit.getClass(code: classNameController.text);
                    subscribeToTopic(topicName: classNameController.text);

                  }

                }

              }, child: Text(cubit.currentUser.isTeacher!?'${getLang(context, "create_name")}':'${getLang(context, "join")}'))
            ],
            title: Text('${getLang(context, "create_class_title")}', style: Theme
                .of(context)
                .textTheme
                .headline1,),
          ),

          body: Container(


            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  defaultEditText(control: classNameController,
                      label:cubit.currentUser.isTeacher!? '${getLang(context, "class_name")}': '${getLang(context, "code")}',
                      validat: (s) {
                        if (s!.isEmpty) {
                          return cubit.currentUser.isTeacher!?'${getLang(context, "class_empty")}': '${getLang(context, "code_empty")}';
                        }
                        else if ( !cubit.currentUser.isTeacher!) {
                          int counterMyClassName = 0;


                          for (int i = 0; i < cubit.myClass.length; i++) {
                            if (s == cubit.myClass[i].code) {counterMyClassName = 1;}


                          }
                          if(counterMyClassName!=1){
                            for (int i = 0; i < listClassName.length; i++) {

                              if (s == listClassName[i]) {counterMyClassName = 2;}


                            }
                          }


                          return counterMyClassName == 1 ? ' you are already joined ' :counterMyClassName == 2?null:'${getLang(context, "not_exist")}';
                        }
                        // else if (cubit.currentUser.isTeacher! &&
                        //     listClassName.isNotEmpty) {
                        //   int counterTeacher = 0;
                        //
                        //   for (int i = 0; i <
                        //       listClassName.length; i++) {
                        //     if (s == listClassName[i]) {
                        //       counterTeacher = 1;
                        //     }
                        //   }
                        //   return counterTeacher == 1
                        //       ? '${getLang(context, "exist")}'
                        //       : null;
                        // }
                        // else if (cubit.currentUser.isTeacher == false) {
                        //   int counterStudent = 0;
                        //
                        //   for (int i = 0; i < listClassName.length; i++) {
                        //     if(s==listClassName[i]){
                        //
                        //     }
                        //
                        //   }
                        //   return counterStudent == 1
                        //       ? null
                        //       : '${getLang(context, "not_exist")}';
                        // }

                        return null;
                      }
                  ),
                  cubit.currentUser.isTeacher! ? Column(
                    children: [
                      SizedBox(height: 20,),

                      defaultEditText(control: subjectController,
                          label: '${getLang(context, "subject_name")}',
                          validat: (s) {
                            if (s!.isEmpty &&
                                cubit.currentUser.isTeacher!) {
                              return '${getLang(context, "subject_empty")}';
                            }
                            return null;
                          }),
                    ],
                  ) : SizedBox(),

                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
