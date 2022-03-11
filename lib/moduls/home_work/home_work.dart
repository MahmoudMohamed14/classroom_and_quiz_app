  import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/moduls/home_work/create_quiz.dart';
import 'package:quizapp/moduls/home_work/quiz_screen.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';

class HomeWork extends StatelessWidget {
  var scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){
        if(state is DeleteQuizSuccessState){
          showToast(text: 'Delete Quiz Successfully', state: ToastState.SUCCESS);
          CubitLayout.get(context).getQuiz();
        }
      },
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          key: scaffoldKey,
       floatingActionButton: CubitApp.get(context).currentUser.isTeacher!?FloatingActionButton(

            onPressed: (){
              navigateTo(context, CreateQuizScreen());

              // if(cubit.isActionOpen) {
              //   scaffoldKey.currentState!.showBottomSheet((context) =>
              //       Container(
              //         width: double.infinity,
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             defaultTextButton(onPress: () {
              //               Navigator.pop(context);
              //               cubit.actionButtonQuiz(isAction: true);
              //
              //               navigateTo(context, CreateQuizScreen());
              //
              //
              //             }, name: 'Create Quiz')
              //
              //           ],
              //
              //         ),
              //       ))
              //       .closed.then((value) {
              //     cubit.actionButtonQuiz(isAction: true);
              //
              //   });
              //   cubit.actionButtonQuiz(isAction: false);
              // }else{
              //   Navigator.pop(context);
              //
              // }
            },
            child: Icon(Icons.add,size: 35,),
          ):SizedBox(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ConditionalBuilder(
              condition: cubit.quizList.isNotEmpty,
              builder: (context)=>ListView.separated(itemBuilder: (context,index)=>quizBuildItem(
                  context: context,
                  quizModel: cubit.quizList[index],
                  quizId: cubit.quizIdList[index],

              ),
                  separatorBuilder: (context,index)=>const SizedBox(height: 20,),
                  itemCount: cubit.quizList.length),
              fallback:(context)=> const Center(
                child:  CircleAvatar(
                  backgroundImage:  AssetImage('assets/image/emptyquiz.jpg',),

                  radius: 150,
                ),
              ),
            ),
          ),


        );
      },

    );

  }
  Widget quizBuildItem({
    context,
    required QuizModel quizModel,
    String ?quizId,}){
    return  InkWell(
      onTap: (){
        if(globalUserModel!.isTeacher!||CacheHelper.getData(key: quizId!+globalUserModel!.email!)==null){
          List<List<String>>listOfAnswer=[];
          List<String>listOfQuestionText=[];
          List<String>listOfAnswerText=[];
          quizModel.questionMap!.forEach((key, value) {
            listOfQuestionText.add( value['question'],);
            listOfAnswerText.add(  value['option1']);
            listOfAnswer.add( [

              value['option4'],
              value['option2'],
              value['option1'],
              value['option3'],

            ]);
          });

          listOfAnswer.forEach((element) {
            element.shuffle();
          });
          CubitLayout.get(context).addNumberOfOption(number: listOfQuestionText.length);
          CubitLayout.get(context). getStudentAnswer(quizId: quizId!);

          navigateTo(context, QuizScreen(QuizId: quizId,
            answerList: listOfAnswer,
            correctAnswer: listOfAnswerText,
            questionList: listOfQuestionText,
            isQuizGame:quizModel.isQuizGame
          ));

        }


      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
               const CircleAvatar(
                  backgroundImage:  AssetImage('assets/image/quizimage.png',),

                  radius: 27,
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${quizModel.title}',style: Theme.of(context).textTheme.headline1,),
                      const SizedBox(height: 5,),
                      Text('${quizModel.date} ',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15,color: Colors.grey),),
                    ],
                  ),
                ),
               if(!globalUserModel!.isTeacher!) Icon(CacheHelper.getData(key: quizId!+globalUserModel!.email!)==null?Icons.check_box_outline_blank:Icons.check_box,color: mainColor,)
                else IconButton(onPressed: (){
                  showDialog(context: context,
                      builder: (context)=> AlertDialog(
                       title: Text('Delete Quiz'),
                        content: Text('Do you want to delete this Quiz ?'),
                        actions: [
                          TextButton(onPressed:(){
                             Navigator.pop(context);
                          }, child: Text('no')),
                          TextButton(onPressed: (){
                            CubitLayout.get(context).deleteQuiz(quizId: quizId!);
                            Navigator.pop(context);
                          }, child: Text('yes')),

                        ],
                      ),
                    barrierDismissible: false

                  );


               }, icon: Icon(Icons.delete,color: mainColor,)),
              ],
            )

          ],
        ),

      ),
    );
  }
}
