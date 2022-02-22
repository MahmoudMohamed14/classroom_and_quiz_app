import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class CreateQuizScreen extends StatelessWidget {
  TextEditingController titleQuizControl=  TextEditingController();
  TextEditingController dateQuizControl=  TextEditingController();
  TextEditingController timeQuizControl=  TextEditingController();
  TextEditingController questionQuizControl=  TextEditingController();
  TextEditingController option1QuizControl=  TextEditingController();
  TextEditingController option2QuizControl=  TextEditingController();
  TextEditingController option3QuizControl=  TextEditingController();
  TextEditingController option4QuizControl=  TextEditingController();

  var keyFormInformation= GlobalKey<FormState>();
  var keyFormQuestion= GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          appBar: AppBar(
            title:Text('Create Quiz',style: Theme.of(context).textTheme.headline1,),
            actions: [
              defaultTextButton(onPress:() {
                var model=QuizModel(
                    title: titleQuizControl.text,
                  date: dateQuizControl.text,
                  time: timeQuizControl.text,
                  questionMap: cubit.questionList.asMap()
                );
                print(model.toMap());

              }, name: 'submit')
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: keyFormQuestion,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    defaultEditText(control: titleQuizControl, label: 'titleQuiz', validat: (s){
                      if(s.toString().isEmpty){
                        return 'title is empty';
                      }
                      return null;
                    },
                      prefIcon: Icons.text_fields
                    ),
                    SizedBox(height: 20,),
                    defaultEditText(control: dateQuizControl, label: 'date', validat: (s)
                    {
                      if(s.toString().isEmpty){
                        return 'date is empty';
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
                    SizedBox(height: 20,),
                    defaultEditText(control: timeQuizControl,
                        label: 'Time',
                        validat: (s) {
                      if(s.toString().isEmpty){
                        return 'date is empty';
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
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
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

                          items:const[
                        DropdownMenuItem<bool>(child: Text('Multiple Choice',),value: true,),
                        DropdownMenuItem<bool>(child: Text('Multiple '),value: false,),
                      ]
                      ),
                    ),
                   const SizedBox(height: 20,),
                    defaultEditText(control: questionQuizControl, label: 'Question ${cubit.questionList.length+1}', validat: (s){
                      if(s.toString().isEmpty){
                        return 'Question is empty';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,
                        onPress: (){}
                    ),
                    const SizedBox(height: 20,),
                    defaultEditText(control: option1QuizControl, label: 'Option1(correct answer)', validat: (s){
                      if(s.toString().isEmpty){
                        return 'Option1 is empty';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,
                      onPress: (){}
                    ),
                    const SizedBox(height: 20,),
                    defaultEditText(
                        control:option2QuizControl,
                        label: 'Option2',
                        validat: (s){
                      if(s.toString().isEmpty){
                        return 'Option2 is empty';
                      }
                      return null;
                    },
                        prefIcon: Icons.text_fields,
                        onPress: (){}
                    ),
                 if(cubit.isMulitpleChoice)   Column(
                      children: [
                        const SizedBox(height: 20,),
                        defaultEditText(control: option3QuizControl, label: 'Option3', validat: (s){
                          if(s.toString().isEmpty&&cubit.isMulitpleChoice){
                            return 'Option3 is empty';
                          }
                          return null;
                        },
                            prefIcon: Icons.text_fields,
                            onPress: (){}
                        ),
                        const SizedBox(height: 20,),
                        defaultEditText(control: option4QuizControl,
                            label: 'Option4', validat: (s){
                          if(s.toString().isEmpty&&cubit.isMulitpleChoice){
                            return 'Option4 is empty';
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
                        QuestionModel questionModel=
                        QuestionModel(question:questionQuizControl.text,
                          optoin1: option1QuizControl.text,
                          optoin2: option2QuizControl.text,
                          optoin3: cubit.isMulitpleChoice?option3QuizControl.text:null,
                          optoin4:cubit.isMulitpleChoice? option4QuizControl.text:null
                        );
                        cubit.addQuestionToList(questionModel: questionModel);
                        questionQuizControl.clear();
                        option1QuizControl.clear();
                        option2QuizControl.clear();
                        option3QuizControl.clear();
                        option4QuizControl.clear();
                        print(cubit.questionList.asMap());


                      }

                    }, name: 'next',
                      width: 100

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
  Widget informationQuiz(){
    return  Form(
      key: keyFormInformation,
      child: Column(
        children: [
          defaultEditText(control: titleQuizControl, label: 'titleQuiz', validat: (s){
            if(s.toString().isEmpty){
              return 'title is empty';
            }
            return null;
          }),
          SizedBox(height: 20,),
          defaultEditText(control: dateQuizControl, label: 'date', validat: (s){
            if(s.toString().isEmpty){
              return 'date is empty';
            }
            return null;
          }),
          SizedBox(height: 20,),
          defaultButton(onPress: (){
            if(keyFormInformation.currentState!.validate()){

            }

          }, name: 'next',
              width: 100

          ),


        ],
      ),
    );
  }
}
