import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/shared/componant/componant.dart';

class CreatePost extends StatelessWidget {

  var textController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){
        if(state is CreatePostSuccessState)
          Navigator.pop(context);

      },
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Post',style: Theme.of(context).textTheme.bodyText1,),
            actions: [
            defaultTextButton(onPress: (){
              String date=DateFormat.yMMMd().format(DateTime.now()).toString();
              cubit.createPost(text: textController.text , date: date);


            }, name: 'post')
            ],

          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if(state is CreatePostLoadingState)
                  Column(
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(height: 20,)
                    ],
                  ),

                TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      hintText: 'Share with your classrooms...?',

                      border: InputBorder.none
                  ),
                  keyboardType: TextInputType.text,
                )
              ],
            ),
          ),
        );
      },

    );
  }
}
