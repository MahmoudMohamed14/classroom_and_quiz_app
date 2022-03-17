import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/chat_model.dart';
import 'package:quizapp/shared/constant/constant.dart';

class ChatDetailScreen extends StatelessWidget {
  var txtController = TextEditingController();
  String?receiverEmail;
  String?receiverName;


  ChatDetailScreen({this.receiverEmail,this.receiverName});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        CubitLayout.get(context).getMessage( receiverEmail:receiverEmail! );
        return BlocConsumer<CubitLayout, StateLayout>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = CubitLayout.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Row(

                  children: [
                  const  CircleAvatar(
                     // backgroundImage: NetworkImage('${userModel!.image}',),
                      foregroundColor: mainColor,
                      radius: 18,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text('${receiverName}', style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(height: 1.4),),

                    ),
                    //Spacer(),
                    SizedBox(width: 15),


                  ],

                ),
              ),
              body:  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),


                            itemBuilder: (context, index) =>
                            myEmail == cubit.messageModel[index].receiverEmail
                                ?
                            buildLeftMessage(cubit.messageModel[index])
                                : buildRightMessage(
                                cubit.messageModel[index])
                            ,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15,)

                            ,
                            itemCount: cubit.messageModel.length),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(.3),
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 5),
                              child: TextFormField(
                                controller: txtController,
                                keyboardType: TextInputType.text,

                                decoration: InputDecoration(

                                    hintText: ' write your message here...',
                                    border: InputBorder.none

                                ),

                              ),
                            ),
                          ),
                          Container(
                            height: 50,

                            color: Colors.green,
                            child: MaterialButton(
                              minWidth: 1,

                              onPressed: () {
                                cubit.sendMessage(
                                    dateTime: DateTime.now().toString(),
                                    text: txtController.text, receiverEmail: receiverEmail!);
                                txtController.clear();
                              },
                              child:const Icon(Icons.send
                                , size: 30,
                                color: Colors.white,),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )
            );
          },

        );
      },

    );
  }

  Widget buildLeftMessage(ChatModel chatModel) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomEnd: Radius.circular(10),
                )
            ),
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
            ),
            child: Text('${chatModel.text}'),
          ),
        ),
      );

  Widget buildRightMessage(ChatModel chatModel) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomStart: Radius.circular(10),
                )
            ),
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
            ),
            child: Text('${chatModel.text}'),
          ),
        ),
      );
}