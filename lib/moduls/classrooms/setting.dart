import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/translate/applocale.dart';

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
            title:  Text('${getLang(context, "setting")}',style: Theme.of(context).textTheme.headline1,),

            actions: [
              defaultTextButton(onPress: (){
                if(formKey.currentState!.validate()){
                 cubit.updateClassRoom(subject: subjectController.text,name: classNameController.text).then((value) {
                   CubitApp.get(context).getMyAllClassRoom();
                 });

                }

              }, name: '${getLang(context, "update")}')
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                 if(state is UpDateClassLoadingState) Column(
                   children:const [
                     LinearProgressIndicator(),
                     SizedBox(height: 20,)
                   ],
                 ),
                  defaultEditText(
                    control: classNameController,
                    label: '${getLang(context, "class_name")}',
                    validat:   ( s){
                      if(s.isEmpty){
                        return'${getLang(context, "name_empty")}';
                      }
                      return null;
                    },),
                  const  SizedBox(height: 20,),
                  defaultEditText(
                    control: subjectController,
                    label: '${getLang(context, "subject_name")}',
                    validat:   ( s){
                     
                      if(s.isEmpty){
                        return'${getLang(context, "subject_empty")}';
                      }
                      return null;
                    },),
                  const  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      Clipboard.setData(new ClipboardData(text: cubit.classRoomModel!.code)).then((value) {
                        showToast(text: 'Copied to Clipboard', state: ToastState.SUCCESS);
                      });

                    },
                    child: Row(
                      children: [
                        Text('${getLang(context, "class_code")}',style: Theme.of(context).textTheme.headline1,),
                        Text('${cubit.classRoomModel!.code}',style: Theme.of(context).textTheme.bodyText1,),
                        Spacer(),
                        Icon(Icons.copy,color:  mainColor,)
                      ],
                    ),
                  ),
                  const  SizedBox(height: 20,),
                  // defaultButton(
                  //   color: Colors.red.shade400,
                  //
                  //   onPress: (){
                  //     showDialog(context: context,
                  //         builder: (context)=> AlertDialog(
                  //           title:const Text('Delete ClassRoom'),
                  //           content:const Text('Do you want to delete this ClassRoom ?'),
                  //
                  //           actions: [
                  //             TextButton(onPressed:(){
                  //               Navigator.pop(context);
                  //             }, child:const Text('no')),
                  //             TextButton(onPressed: (){
                  //
                  //               Navigator.pop(context);
                  //             }, child:const Text('yes')),
                  //
                  //           ],
                  //         ),
                  //         barrierDismissible: false
                  //
                  //     );
                  //
                  //
                  //
                  //   }, name: '${getLang(context, "delete")}',
                  //
                  //
                  // ),


                ],
              ),
            ),
          ),
        );
      } ,

    );
  }
}
