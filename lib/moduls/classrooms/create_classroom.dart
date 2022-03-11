import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class CreateClassScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var classNameController = TextEditingController();
  var subjectController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
      listener: (context, state) {
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
                    cubit.createClass(classRoom: ClassRoom(className:
                    classNameController.text,
                      subject: subjectController.text,
                      teacherEmail: cubit.currentUser.email,
                      teacherName: cubit.currentUser.name,));

                  }else{
                    cubit.getClass(className: classNameController.text);
                    subscribeToTopic(topicName: classNameController.text.toString());
                  }

                }

              }, child: Text(cubit.currentUser.isTeacher!?'Create':'Join'))
            ],
            title: Text('CreateClassRoom', style: Theme
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
                      label: 'classroom name',
                      validat: (s) {
                        if (s!.isEmpty) {
                          return 'classrooms name is empty';
                        }
                        else if (cubit.myClass.isNotEmpty &&
                            !cubit.currentUser.isTeacher!) {
                          int counterMyClassName = 0;


                          for (int i = 0; i <
                              cubit.myClass.length; i++) {
                            if (s == cubit.myClass[i].className) {
                              counterMyClassName = 1;
                            }
                          }
                          return counterMyClassName == 1
                              ? ' you are already joined '
                              : null;
                        }
                        else if (cubit.currentUser.isTeacher! &&
                            listClassName.isNotEmpty) {
                          int counterTeacher = 0;

                          for (int i = 0; i <
                              listClassName.length; i++) {
                            if (s == listClassName[i]) {
                              counterTeacher = 1;
                            }
                          }
                          return counterTeacher == 1
                              ? 'already exist try anther classNme '
                              : null;
                        }
                        else if (!cubit.currentUser.isTeacher!) {
                          int counterStudent = 0;

                          for (int i = 0; i <
                              listClassName.length; i++) {
                            if (s.toString().trim() ==
                                listClassName[i].trim()) {
                              counterStudent = 1;
                            }
                          }
                          return counterStudent == 1
                              ? null
                              : 'not exist ';
                        }

                        return null;
                      }
                  ),
                  cubit.currentUser.isTeacher! ? Column(
                    children: [
                      SizedBox(height: 20,),

                      defaultEditText(control: subjectController,
                          label: 'subject',
                          validat: (s) {
                            if (s!.isEmpty &&
                                cubit.currentUser.isTeacher!) {
                              return 'subject is empty';
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
