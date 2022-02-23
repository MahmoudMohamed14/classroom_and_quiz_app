// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/layout_screen.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/models/menu_class_model.dart';
import 'package:quizapp/moduls/login/login_screen.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class ClassScreen extends StatelessWidget {
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var classNameController=TextEditingController();
  var subjectController=TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CubitApp,StateApp>(
      listener: (context,state)
      {

        if(state is SuccessCreateClassState){
          Navigator.pop(context);
          showToast(text: 'Class Created Successfully', state: ToastState.SUCCESS);

        }else if(state is GetClassSuccessState){
          Navigator.pop(context);
        }
        else if(state is AddStudentToClassSuccessState){
          showToast(text: 'Add Student To Class Successfully', state: ToastState.SUCCESS);
        }
        else if(state is AddStudentToClassErrorState){
          showToast(text: state.error!, state: ToastState.ERROR);

        }else if(state is GetClassErrorState){
          showToast(text: state.error!, state: ToastState.ERROR);

        }else if(state is ErrorAddClassToTeacherState){
          showToast(text: state.error!, state: ToastState.ERROR);

        }else if(state is ErrorCreateClassState){
          showToast(text: state.error!, state: ToastState.ERROR);

        }
      },
      builder:(context,state){
        var cubit=CubitApp.get(context);
        return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: SizedBox(),

          leadingWidth: 10,
          actions: [
            IconButton(onPressed: (){
              if(!cubit.isActionOpen){
                cubit.actionButton(isAction: true);
                signOut(context,LoginScreen());
              }else{
                signOut(context,LoginScreen());
              }


            }, icon: Icon(Icons.logout))
          ],
          title: Text('MyClass',style: Theme.of(context).textTheme.headline1,),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            print('test is obin ${cubit.isActionOpen}');


               if(cubit.isActionOpen)

            {

              scaffoldKey.currentState!.showBottomSheet((context) => Container(

                    color: Colors.grey[100],
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          defaultEditText(control: classNameController, label: 'classrooms name',
                              validat: (s) {
                            if(s!.isEmpty)
                            {
                              return'classrooms name is empty';
                            }
                            else if (cubit.myClass.isNotEmpty && !cubit.currentUser.isTeacher!)
                            {
                              int counterMyClassName =0;


                              for(int i=0;i<cubit.myClass.length;i++) {
                                if (s == cubit.myClass[i].className) {
                                  counterMyClassName =1;
                                }
                              }
                              return counterMyClassName == 1 ? ' you are already joined ' : null;

                            }
                            else if(cubit.currentUser.isTeacher! && listClassName .isNotEmpty)
                            {
                              int counterTeacher=0;

                              for(int i=0;i<listClassName.length;i++){
                                if(s == listClassName[i]){
                                  counterTeacher=1;
                                }

                              }
                              return counterTeacher==1?'already exist try anther classNme ':null;



                            }
                            else if(!cubit.currentUser.isTeacher! )
                            {

                              int counterStudent=0;

                              for(int i=0;i<listClassName.length;i++){
                                if(s.toString().trim()== listClassName[i].trim() ) {
                                  counterStudent=1;
                                }


                              }
                              return counterStudent==1?null:'not exist ';

                            }

                            return null;

                          }
                          ),
                          cubit.currentUser.isTeacher!?  Column(
                            children: [
                              SizedBox(height: 20,),

                              defaultEditText(control: subjectController, label: 'subject', validat: (s){
                                if(s!.isEmpty && cubit.currentUser.isTeacher!){
                                  return'subject is empty';
                                }
                                return null;
                              }),
                            ],
                          ):SizedBox(),

                        ],
                      ),
                    ),
                  )).closed.then((value) {
                classNameController.clear();
                subjectController.clear();
                cubit.actionButton(isAction: true);
                print(cubit.isActionOpen);

              });
              cubit.actionButton(isAction: false);
              print(cubit.isActionOpen);
            }
               else
               {
                 if(formKey.currentState!.validate()){
                   cubit.currentUser.isTeacher!? cubit.createClass(classRoom: ClassRoom(className: classNameController.text, subject: subjectController.text, teacherEmail: cubit.currentUser.email, teacherName: cubit.currentUser.name,)):cubit.getClass(className: classNameController.text);
                   cubit.actionButton(isAction: true);

                   print(cubit.isActionOpen);
                 }
               }
          },
          child: Icon(Icons.add,size: 35,),

        ),
         body: ConditionalBuilder(
          condition:cubit.myClass.length>0 ,
          builder:(context)=> ListView.separated(
               itemBuilder: (context,index)=>buildClassRoomItem(context: context,model: cubit.myClass[index],classId: cubit.myClassId[index]),
               separatorBuilder: (context,index)=>SizedBox(),
               itemCount: cubit.myClass.length),
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

        navigateTo(context, LayoutScreen(model: model,));
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model!.className}',style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.white),),
                      SizedBox(height: 5,),
                      Text('${model.subject}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),
                    ],
                  ),
                  Spacer(),

                    PopupMenuButton(
                      onSelected: (value){
                        switch (value ){
                          case 'edit':{
                            showToast(text: value.toString(), state: ToastState.SUCCESS);
                         break;
                          }
                          case 'delete':{
                            showToast(text: value.toString(), state: ToastState.SUCCESS);
                            break;
                          }
                          case 'unenroll':{
                            CubitApp.get(context).deleteStudentToClassRoom(className:model.className!,studentEmail: myEmail!);
                            CubitApp.get(context).deleteClassRoomFromStudent(className:model.className! );

                            showToast(text: value.toString(), state: ToastState.SUCCESS);

                            break;
                          }


                        }
                      },


                      icon: Icon(Icons.more_vert,color: Colors.white,),

                      itemBuilder: (BuildContext context){
                      return CubitApp.get(context).currentUser.isTeacher!?
                      MenuItem.menuListTeacher.map(( String e) {
                        return PopupMenuItem<String>(


                          value: e,
                            child:Text(e) );
                      }).toList(): MenuItem.menuListStudent.map(( String e) {
                        return PopupMenuItem<String>(


                            value: e,
                            child:Text(e) );
                      }).toList();

                    },

                    )

                ],
              ),
              SizedBox(height: 50,),
              Text('${model.teacherName}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),


            ],
          ),
        ),
      ),
    );
  }
}
