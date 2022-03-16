import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class CreateQuizScreen extends StatelessWidget {
  TextEditingController titleQuizControl=  TextEditingController();
  TextEditingController dateQuizControl=  TextEditingController();
  TextEditingController timeQuizControl=  TextEditingController();
  TextEditingController questionQuizControl=  TextEditingController();
  TextEditingController option1QuizControl=  TextEditingController();
  TextEditingController option2QuizControl=  TextEditingController();
  TextEditingController option3QuizControl=  TextEditingController();
  TextEditingController option4QuizControl=  TextEditingController();
 late QuestionModel  questionModel;


  var keyFormQuestion= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){
        if(state is GetQuizSuccessState){
          showToast(text: 'add quiz', state: ToastState.SUCCESS);
          DioHelper.postNotification(to: '/topics/${CubitLayout.get(context).classRoomModel!.className!}',
              title: CubitLayout.get(context).classRoomModel!.className!,
              body: '${globalUserModel!.name} create new quiz',
              data: {'addToClaas':'false','deleteClass':'false','className':'', "type": "order",
                "id": "87",
                "click_action": "FLUTTER_NOTIFICATION_CLICK"}
          );

        }
      },
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          appBar: AppBar(
            title:Text('${getLang(context, "create_quiz")}',style: Theme.of(context).textTheme.headline1,),
            actions: [
              defaultTextButton(onPress:() {
        if(keyFormQuestion.currentState!.validate()) {

          cubit.addQuestionToList(
              question: questionQuizControl.text,
              option1: option1QuizControl.text,
              option2: option2QuizControl.text,
            option3: option3QuizControl.text,
            option4: option4QuizControl.text
          );
          cubit.questionList.map((e) {

          });
          Map<String, Map<String, dynamic>> questionMap={};
          for(int i=0;i<cubit.questionList.length;i++){
            questionMap['${i}']=cubit.questionList[i];
          }


          var quizModel = QuizModel(
              title: titleQuizControl.text,
              date: dateQuizControl.text,
              time: timeQuizControl.text,
              questionMap: questionMap,
              isQuizGame: cubit.isQuizGame
          );
         cubit.uploadQuiz(quizModel:quizModel,context: context );
          print(quizModel.questionMap);
        }

              }, name: '${getLang(context, "submit_name")}')
            ],
          ),
          body: SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: keyFormQuestion,
                child: Column(
                  children: [
                    state is UploadingQuizLoadingState? Column(
                     children: const[
                       SizedBox(height: 20,),
                       LinearProgressIndicator(),
                       SizedBox(height: 20,),
                     ],
                    ):const SizedBox(),
                    defaultEditText(control: titleQuizControl, label: '${getLang(context, "titleQuiz_name")}', validat: (s){
                      if(s.toString().isEmpty){
                        return '${getLang(context, "titleQuiz_name")}';
                      }
                      return null;
                    },
                      prefIcon: Icons.text_fields
                    ),
                    const  SizedBox(height: 20,),
                    defaultEditText(control: dateQuizControl, label: '${getLang(context, "date_name")}', validat: (s)
                    {
                      if(s.toString().isEmpty){
                        return '${getLang(context, "date_empty")}';
                      }
                      return null;
                    },
                        onPress: (){

                        showDatePicker
                          (context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2023-01-01')).then((value) {
                              dateQuizControl.text=DateFormat.yMMMd() .format(value!).toString();

                        });
                      },
                      textType: TextInputType.none,
                      prefIcon: Icons.date_range

                    ),
                    const SizedBox(height: 20,),
                    defaultEditText(control: timeQuizControl,
                        label: '${getLang(context, "time_name")}',
                        validat: (s) {
                      if(s.toString().isEmpty){
                        return '${getLang(context, "time_empty")}';
                      }
                      return null;
                    },
                        onPress: (){
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                           timeQuizControl.text=value!.format(context).toString();
                          });

                        },
                        textType: TextInputType.none,
                      prefIcon: Icons.access_time

                    ),
                    const SizedBox(height: 20,),
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
                        iconSize: 36,
                        value: cubit.isMulitpleChoice,
                          onChanged: ( s){
                          cubit.dropDownBotton(ischoice: s);
                          },

                          items:[
                        DropdownMenuItem<bool>(child: Text('${getLang(context, "choice_name")}',),value: true,),
                        DropdownMenuItem<bool>(child: Text('${getLang(context, "trueandfalse_name")}'),value: false,),
                      ]
                      ),
                    ),
                    const SizedBox(height: 20,),
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
                          iconSize: 36,
                          value: cubit.isQuizGame,
                          onChanged: ( s){
                            cubit.dropDownBottonQuizGame(isQuiz: s);
                            print(cubit.isQuizGame);
                          },

                          items:[
                            DropdownMenuItem<bool>(child: Text( '${getLang(context, "normal_quiz")}',),value: false,),
                            DropdownMenuItem<bool>(child: Text( '${getLang(context, "quiz_game")}'),value: true,),
                          ]
                      ),
                    ),
                   const SizedBox(height: 20,),
                    defaultEditText(control: questionQuizControl, label: '${getLang(context, "question_name")}${cubit.questionList.length+1}', validat: (s){
                      if(s.toString().isEmpty){
                        return '${getLang(context, "question_empty")}';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,

                    ),
                    const SizedBox(height: 20,),
                    defaultEditText(control: option1QuizControl, label: '${getLang(context, "option1_name")}', validat: (s){
                      if(s.toString().isEmpty){
                        return '${getLang(context, "option1_empty")}';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,
                      onPress: (){}
                    ),
                    const SizedBox(height: 20,),
                    defaultEditText(
                        control:option2QuizControl,
                        label: '${getLang(context, "option2_name")}',
                        validat: (s){
                      if(s.toString().isEmpty){
                        return '${getLang(context, "option2_empty")}';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,

                    ),
                 if(cubit.isMulitpleChoice)   Column(
                      children: [
                        const SizedBox(height: 20,),
                        defaultEditText(control: option3QuizControl, label: '${getLang(context, "option3_name")}', validat: (s){
                          if(s.toString().isEmpty&&cubit.isMulitpleChoice){
                            return '${getLang(context, "option3_empty")}';
                          }
                          return null;
                        },
                            prefIcon: Icons.text_fields,

                        ),
                        const SizedBox(height: 20,),
                        defaultEditText(control: option4QuizControl,
                            label: '${getLang(context, "option4_name")}', validat: (s){
                          if(s.toString().isEmpty&&cubit.isMulitpleChoice){
                            return '${getLang(context, "option4_empty")}';
                          }
                          return null;
                        },
                            prefIcon: Icons.text_fields,
                            onPress: (){}
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    defaultButton(onPress: (){
                      if(keyFormQuestion.currentState!.validate()){
                        cubit.addQuestionToList(
                            question: questionQuizControl.text,
                            option1: option1QuizControl.text,
                            option2: option2QuizControl.text,
                            option3: option3QuizControl.text,
                            option4: option4QuizControl.text
                        );
                        questionQuizControl.clear();
                        option1QuizControl.clear();
                        option2QuizControl.clear();
                        option3QuizControl.clear();
                        option4QuizControl.clear();
                        print(cubit.questionList.asMap());
                      }

                    }, name: '${getLang(context, "question_next")}',


                    ),


                  ],
                ),
              ),
            ),
          ),

        );
      },

    );
  }

}
