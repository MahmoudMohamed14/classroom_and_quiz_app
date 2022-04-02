import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/student_model.dart';
import 'package:quizapp/moduls/chat/chat_screen.dart';
import 'package:quizapp/moduls/people/addstudent.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class PeopleScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout, StateLayout>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CubitLayout.get(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${getLang(context, "teachers_name")}', style: Theme
                    .of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 24),),
                const SizedBox(height: 5,),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black26,
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    if(!globalUserModel!.isTeacher!) navigateTo(context, ChatDetailScreen(receiverEmail: cubit.classRoomModel!.teacherEmail,receiverName: cubit.classRoomModel!.teacherName,));
                  },
                  child: Container(
                    width: double.infinity,

                    child: Card(

                      shadowColor: mainColor,
                      shape: RoundedRectangleBorder(


                        borderRadius: BorderRadius.circular(5),


                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(child: Text(
                              cubit.classRoomModel!.teacherName!, maxLines: 1,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!,)),
                            if(!globalUserModel!.isTeacher!)   Icon(Icons.message)


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  children: [
                    Row(
                      children: [
                        Text('${getLang(context, "students_name")}', style: Theme
                            .of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 24),),
                        SizedBox(width: 5,),
                        Text('${cubit.listStudent.length.toString()}', style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 24),),
                      ],

                    ),
                    const Spacer(),
                    if(CubitApp
                        .get(context)
                        .currentUser
                        .isTeacher!) InkWell(
                      onTap: () {
                        navigateTo(context, AddStudent());
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),

                        child: Icon(Icons.add, color: mainColor,),
                        decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            shape: BoxShape.circle

                        ),
                      ),
                    )

                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black26,
                ),
                const SizedBox(height: 20,),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cubit.listStudent.length,
                  itemBuilder: (context, index) => buildStudentItem(
                      context: context,
                      studentModel: cubit.listStudent[index]),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 20,),

                ),
              ],
            ),
          ),
        );
      },


    );
  }

  Widget buildStudentItem({context, required StudentModel studentModel}) {
    List<String>deletePost=['${getLang(context, "delete")}'];
    return InkWell(
      onTap: () {
       if(globalUserModel!.isTeacher!) navigateTo(context,ChatDetailScreen(receiverEmail: studentModel.studentEmail,receiverName: studentModel.studentName,) );

      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all()


        ),

        child: Row(

          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${studentModel.studentName}', maxLines: 1, style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1!,),
            )),

            CubitApp
                .get(context)
                .currentUser
                .isTeacher! ?
            PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (value) {
                  if (value == '${getLang(context, "delete")}') {
                    CubitApp.get(context).deleteClassRoomFromStudent(
                        code: CubitLayout
                            .get(context)
                            .classRoomModel!
                            .code!,
                        studentEmail: studentModel.studentEmail!);

                    CubitApp.get(context).deleteStudentToClassRoom(
                       code: CubitLayout
                            .get(context)
                            .classRoomModel!
                            .code!,
                        studentEmail: studentModel.studentEmail!);
                    CubitLayout.get(context).getAllStudent();
                    CubitApp
                        .get(context)
                        .allUser
                        .forEach((element) {
                      if (studentModel.studentEmail == element.email) {
                        DioHelper.postNotification(to: element.token!,
                            title: CubitLayout
                                .get(context)
                                .classRoomModel!
                                .className!,
                            body: 'your teacher  delete you',
                            data: {
                              "type": "order",
                              "id": "87",
                              'payload': 'unsub${CubitLayout.get(context).classRoomModel!.code!}',
                              "click_action": "FLUTTER_NOTIFICATION_CLICK",


                            });
                      }
                    });
                  }
                },

                icon: Icon(Icons.more_vert, color: mainColor,),

                itemBuilder: (context) {
                  return deletePost.map((String e) {
                    return PopupMenuItem<String>(
                        height: 20,
                        value: e,
                        child: Text(e)
                    );
                  }).toList();
                }) : SizedBox()

          ],
        ),
      ),
    );

  }



}
