  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/moduls/home_work/create_quiz.dart';
import 'package:quizapp/shared/componant/componant.dart';

class HomeWork extends StatelessWidget {
  var scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(cubit.isActionOpen) {
                scaffoldKey.currentState!.showBottomSheet((context) =>
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextButton(onPress: () {
                            Navigator.pop(context);
                            cubit.actionButtonQuiz(isAction: true);

                            navigateTo(context, CreateQuizScreen());


                          }, name: 'Create Quiz')

                        ],

                      ),
                    ))
                    .closed.then((value) {
                  cubit.actionButtonQuiz(isAction: true);

                });
                cubit.actionButtonQuiz(isAction: false);
              }else{
                Navigator.pop(context);

              }
            },
            child: Icon(Icons.add,size: 35,),
          ),
        );
      },

    );

  }
}
