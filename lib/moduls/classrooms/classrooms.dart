// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/layout_screen.dart';
import 'package:quizapp/models/class_room_model.dart';

import 'package:quizapp/moduls/classrooms/create_classroom.dart';

import 'package:quizapp/moduls/login/login_screen.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class ClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CubitApp,StateApp>(
      listener: (context,state)
      {

        // if(state is SuccessCreateClassState){
        //
        //   Navigator.pop(context);
        //   showToast(text: 'Class Created Successfully', state: ToastState.SUCCESS);
        //
        // }else if(state is GetClassSuccessState){
        //   Navigator.pop(context);
        //  }
        // else if(state is AddStudentToClassSuccessState){
        //   showToast(text: 'Add Student To Class Successfully', state: ToastState.SUCCESS);
        //
        // }
        // else if(state is AddStudentToClassErrorState){
        //   showToast(text: state.error!, state: ToastState.ERROR);
        //
        // }else if(state is GetClassErrorState){
        //   showToast(text: state.error!, state: ToastState.ERROR);
        //
        // }else if(state is ErrorAddClassToTeacherState){
        //   showToast(text: state.error!, state: ToastState.ERROR);
        //
        // }else if(state is ErrorCreateClassState){
        //   showToast(text: state.error!, state: ToastState.ERROR);
        //
        // }
      },
      builder:(context,state){
        var cubit=CubitApp.get(context);
        return Scaffold(

        appBar: AppBar(
          leading: SizedBox(),

          leadingWidth: 10,
          actions: [
            // IconButton(onPressed: (){
            //
            //     signOut(context,LoginScreen());
            //
            //
            //
            // }, icon: Icon(Icons.logout))
          ],
          title: Text('${getLang(context, "myClass")}',style: Theme.of(context).textTheme.headline1,),
        ),
        endDrawer: Drawer(
          child: ListView(

              children: [
                UserAccountsDrawerHeader(
                    accountName: Text(globalUserModel?.name??'',style: TextStyle(color: Colors.white),),
                    accountEmail:Text(globalUserModel?.email??'',style: TextStyle(color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.white,
                  ),

                ),
               Padding(
                 padding: const EdgeInsets.all(10),
                 child: Row(
                   children: [
                     Icon(Icons.language),
                    const SizedBox(width: 5,),
                     Text('${getLang(context, 'language')}',style: Theme.of(context).textTheme.bodyText1,)
                   ],
                 ),
               ),
               Container(width: double.infinity,height: 1,color: Colors.black,),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                      child:  Container(
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
                            value: CubitApp.get(context).lang,
                            onChanged: ( s){
                              CubitApp.get(context).changeLang(lange: s);
                            },

                            items:const[
                              DropdownMenuItem<String>(child: Text( "English",),value: 'en',),
                              DropdownMenuItem<String>(child: Text( "عربي"),value: 'ar',),
                            ]
                        ),
                      ),
                )
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      signOut(context,LoginScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(Icons.logout,color: Colors.red,),
                          const SizedBox(width: 7,),
                          Text('${getLang(context, 'log_out')}',style: TextStyle(color: Colors.red),),
                        ],
                      ),






                    ),
                  ),
                ),
              ]
          )

        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            navigateTo(context, CreateClassScreen());

          },
          child: Icon(Icons.add,size: 35,),

        ),
         body: ConditionalBuilder(
          condition:cubit.myClass.length>0 ,
          builder:(context)=> Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
                 itemBuilder: (context,index)=>buildClassRoomItem(context: context,model: cubit.myClass[index],classId: cubit.myClassId[index]),
                 separatorBuilder: (context,index)=>SizedBox(
                   height: 20,
                 ),
                 itemCount: cubit.myClass.length),
          ),
           fallback: (context)=> state is GetMyAllClassLoadingState?Center(child: CircularProgressIndicator()):Center(child: Text('No ClassRoom',style: Theme.of(context).textTheme.headline1!.copyWith(color:Colors.grey ),)),
         ),
      );},

    );
  }
  Widget buildClassRoomItem({ context,ClassRoom? model,classId}){
    return InkWell(
      onTap: (){
        CubitLayout.get(context).setClassRoomAndId(model!,classId);
        CubitLayout.get(context).changeBottomNav(index: 0);
        CubitLayout.get(context).getQuiz();
       // if(Platform.isAndroid) subscribeToTopic(topicName: model.code!);

        navigateTo(context, LayoutScreen(model: model,));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),


        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.cyan
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model!.className}',style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),),
                      SizedBox(height: 5,),
                      Text('${model.subject}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),
                    ],
                  ),
                ),


                  PopupMenuButton(

                    onSelected: (value){

                        if('${getLang(context, "delete")}'==value){
                          CubitLayout.get(context).getAllStudent(code: model.code,formOut: true);

                          showDialog(context: context,
                              builder: (context)=> AlertDialog(
                                title: Text('${getLang(context, "delete_class")}'),
                                content:Text('${getLang(context, "wantDelete_class")}'),

                                actions: [
                                  TextButton(onPressed:(){
                                    Navigator.pop(context);
                                  }, child: Text('${getLang(context, "no")}')),
                                  TextButton(onPressed: (){

                                  CubitLayout.get(context).listStudent.forEach((element) {
                                      CubitApp.get(context).deleteClassRoomFromStudent(code: model.code!,studentEmail: element.studentEmail);

                                    });
                                  CubitApp.get(context).deleteClass(code: model.code!);
                                  DioHelper.postNotification(to: '/topics/${model.code!}',
                                      title: model.className!,
                                      body: 'you teacher has delete this class',
                                      data: { 'payload': 'unsub${model.code!}',});
                                  CubitApp.get(context).deleteClassRoomFromStudent(code: model.code!,studentEmail: model.teacherEmail,);

                                  showToast(text: value.toString(), state: ToastState.SUCCESS);

                                    Navigator.pop(context);
                                  }, child: Text('${getLang(context, "yes")}')),

                                ],
                              ),
                              barrierDismissible: false

                          );


                        }
                       if( '${getLang(context, "unenroll")}'==value){
                          CubitApp.get(context).deleteStudentToClassRoom(code:model.code!,studentEmail: myEmail!);
                          CubitApp.get(context).deleteClassRoomFromStudent(code:model.code! );
                             unSubscribeToTopic(topicName: model.code!);

                          showToast(text: value.toString(), state: ToastState.SUCCESS);


                        }



                    },


                    icon: Icon(Icons.more_vert,color: Colors.white,),

                    itemBuilder: (BuildContext context){
                    return CubitApp.get(context).currentUser.isTeacher!?

                       [ PopupMenuItem<String>(


                        value: '${getLang(context, "delete")}',
                          child:Text('${getLang(context, "delete")}') )]
                    : [ PopupMenuItem<String>(


                        value: '${getLang(context, "unenroll")}',
                        child:Text('${getLang(context, "unenroll")}') )];

                  },

                  )

              ],
            ),
            SizedBox(height: 20,),
           // Text('${model.teacherName}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),


          ],
        ),
      ),
    );
  }
}
