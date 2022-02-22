import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/student_model.dart';
import 'package:quizapp/moduls/people/addstudent.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class PeopleScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teachers',style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),),
                const SizedBox(height: 5,),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black26,
                ),
                const SizedBox(height: 10,),
                Container(
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
                          Expanded(child: Text('Mahmoud mohamed abdall',maxLines:1,style: Theme.of(context).textTheme.bodyText1!,)),


                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Row(
                  children: [
                    Text('Students',style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),),
                    Spacer(),

                  ],
                ),
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
                  itemBuilder: (context,index)=>buildStudentItem(context: context,studentModel: cubit.listStudent[index]),
                  separatorBuilder:(context,index)=>const SizedBox(height: 20,) ,

                ),
              ],
            ),
          ),
        );
      },


    );
  }
  Widget buildStudentItem({context, required StudentModel studentModel})=>InkWell(
    onTap: (){
    if(CubitApp.get(context) .currentUser.isTeacher!) navigateTo(context, AddStudent());
    },
    child: Container(
      padding: EdgeInsetsDirectional.only(top: 10,bottom: 10 ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all()


      ),

      child: Row(

        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('${studentModel.studentName}',maxLines:1,style: Theme.of(context).textTheme.bodyText1!,),
          )),

       CubitApp.get(context).currentUser.isTeacher!?
       PopupMenuButton(
         padding: EdgeInsets.all(0),
       onSelected: (value){
         if(value=='delete'){
           CubitApp.get(context).deleteClassRoomFromStudent(className: CubitLayout.get(context).classRoomModel!.className!,studentEmail: studentModel.studentEmail!);
          CubitApp.get(context).deleteStudentToClassRoom(className:CubitLayout.get(context).classRoomModel!.className!,studentEmail: studentModel.studentEmail!);

           CubitLayout.get(context).getAllStudent();
         }
       },

              icon: Icon(Icons.more_vert,color: mainColor,),

              itemBuilder: (context){
                return deletePost.map(( String e) {
                  return PopupMenuItem<String>(
                    height: 20,



                      value: e,
                      child:Text(e)
                  );
                }).toList();
              }):SizedBox()

        ],
      ),
    ),
  );
  List<String>deletePost=['delete'];

}
