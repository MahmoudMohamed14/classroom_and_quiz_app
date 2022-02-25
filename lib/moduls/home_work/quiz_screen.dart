import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/shared/constant/constant.dart';

class QuizScreen extends StatelessWidget {
  List answerList=[];
  List questionList=[];
  List correctAnswer=[];


  QuizScreen({required this.answerList, required this.questionList, required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder:(context,state){
        return  Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
                itemBuilder: (context,index)=>buildQuistionItem(
                    context: context,
                    counter: 0,
                    correctAnswer: correctAnswer[index],
                    question: questionList[index]
                    ,answerList: answerList[index],
                  index: index
                ),
                separatorBuilder: (context,index)=>const SizedBox(height: 20,),
                itemCount: questionList.length),
          ),
        );
      } ,

    );
  }
  Widget buildQuistionItem({
    context,
    required String question,
    required List answerList,
    required String correctAnswer,
    required int counter,
    required int index,

  }){


    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q${index+1}:',style: Theme.of(context).textTheme.headline1,
            ),
            const  SizedBox(width: 5,),
            Expanded(child: Text(
              ' ${question}'
              ,style: Theme.of(context).textTheme.headline1
              ,textAlign: TextAlign.start,
            ),

            ),

          ],
        ),
        const SizedBox(height: 20,),
      if(answerList[0]!='null')

        Column(
          children: [
            InkWell(
              onTap: (){

               CubitLayout.get(context).selectOption( option: answerList[0],index: index );


              },
              splashColor: mainColor,

              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,


                decoration: BoxDecoration(
                  color:   CubitLayout.get(context).optionSelectList[index]==answerList[0]? CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[0]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),

        if(answerList[1]!='null')
          Column(
            children: [
              InkWell(
              onTap: (){

                CubitLayout.get(context).selectOption( option: answerList[1],index: index );

              },
              splashColor: mainColor,

              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color:CubitLayout.get(context).optionSelectList[index]==answerList[1]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[1]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
        ),
              const SizedBox(height: 20,),
            ],
          ),

        if(answerList[2]!='null')
          Column(
            children: [
              InkWell(
              onTap: (){


                CubitLayout.get(context).selectOption( option: answerList[2],index: index );

              },
              splashColor: mainColor,

              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color:CubitLayout.get(context).optionSelectList[index]==answerList[2]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[2]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
        ),
              const SizedBox(height: 20,),
            ],
          ),

        if(answerList[3]!='null')
          InkWell(
          onTap: (){

            CubitLayout.get(context).selectOption( option: answerList[3],index: index );

          },
          splashColor: mainColor,

          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: CubitLayout.get(context).optionSelectList[index]==answerList[3]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(20)

            ),
            child: Text('${answerList[3]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
          ),
        ),


      ],

    );
  }
}
