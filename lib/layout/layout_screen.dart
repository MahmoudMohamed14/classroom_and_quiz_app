
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/moduls/people/people.dart';
import 'package:quizapp/moduls/posts/posts_screen.dart';
import 'package:quizapp/shared/constant/constant.dart';

class LayoutScreen extends StatelessWidget {

   ClassRoom ?model;
  // ignore: use_key_in_widget_constructors
  LayoutScreen({ required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context ,state){

      },
      builder: (context ,state){
        var cubit =CubitLayout.get(context);
        return Scaffold(
          appBar: AppBar(


            title: Text('MyClass',style: Theme.of(context).textTheme.headline1,),

          ),
          body: cubit.listWidget[cubit.index],
          bottomNavigationBar:
          BottomNavigationBar(
            currentIndex: cubit.index,
            onTap: (index){
              cubit.changeBottomNav(index: index);

            },
              items:  [
          BottomNavigationBarItem(icon:Icon(Icons.chat),label: 'Posts'),
          BottomNavigationBarItem(icon:Icon(Icons.work),label: 'HomeWork'),
          BottomNavigationBarItem(icon:Icon(Icons.people),label: 'Peoole'),
              ],
          ),


        );
      },

    );
  }
}