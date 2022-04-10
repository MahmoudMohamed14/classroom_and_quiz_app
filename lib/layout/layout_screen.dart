

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/moduls/classrooms/setting.dart';

import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/translate/applocale.dart';

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
            
            actions: [
              if(globalUserModel!.isTeacher!)  IconButton(onPressed:(){
             navigateTo(context, SettingClassRoomScreen());
              } ,icon: Icon(Icons.settings))
            ],
            title: Text(cubit.titleList(context)[cubit.index],style: Theme.of(context).textTheme.headline1,),
          ),
          body: cubit.listWidget[cubit.index],
          bottomNavigationBar:
          BottomNavigationBar(
            currentIndex: cubit.index,
            onTap: (index){
              cubit.changeBottomNav(index: index);

            },
              items:  [
          BottomNavigationBarItem(icon:Icon(Icons.chat),label: '${getLang(context, "posts")}'),
          BottomNavigationBarItem(icon:Icon(Icons.work),label: '${getLang(context, "quiz_name")}'),
          BottomNavigationBarItem(icon:Icon(Icons.people),label: '${getLang(context, "member")}'),
              ],
          ),


        );
      },

    );
  }
}
