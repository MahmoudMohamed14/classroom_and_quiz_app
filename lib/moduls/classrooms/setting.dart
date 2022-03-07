import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/shared/componant/componant.dart';

class SettingClassRoomScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();
  var classNameController=TextEditingController();
  var subjectController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context,state){},
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        classNameController.text=cubit.classRoomModel!.className!;
        subjectController.text=cubit.classRoomModel!.subject!;

        return  Scaffold(
          appBar: AppBar(
            actions: [
              defaultTextButton(onPress: (){
                if(formKey.currentState!.validate()){

                }

              }, name: 'update')
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  defaultEditText(
                    control: classNameController,
                    label: 'ClassName',
                    validat:   ( s){
                      if(s.isEmpty){
                        return'password is Empty';
                      }
                      return null;
                    },),
                  const  SizedBox(height: 20,),
                  defaultEditText(
                    control: subjectController,
                    label: 'ClassSubject',
                    validat:   ( s){
                      if(s.isEmpty){
                        return'password is Empty';
                      }
                      return null;
                    },),
                  const  SizedBox(height: 20,),
                  defaultButton(
                    color: Colors.red.shade400,

                    onPress: (){
                      showDialog(context: context,
                          builder: (context)=> AlertDialog(
                            title:const Text('Delete ClassRoom'),
                            content:const Text('Do you want to delete this ClassRoom ?'),

                            actions: [
                              TextButton(onPressed:(){
                                Navigator.pop(context);
                              }, child:const Text('no')),
                              TextButton(onPressed: (){

                                Navigator.pop(context);
                              }, child:const Text('yes')),

                            ],
                          ),
                          barrierDismissible: false

                      );



                    }, name: 'Delete',


                  ),


                ],
              ),
            ),
          ),
        );
      } ,

    );
  }
}
