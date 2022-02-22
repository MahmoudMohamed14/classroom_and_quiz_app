
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/post_model.dart';
import 'package:quizapp/moduls/posts/create_posts.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';

class postScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=CubitLayout.get(context);
        return SingleChildScrollView(
          scrollDirection:Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    navigateTo(context, CreatePost());
                  },
                  child: Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: mainColor)
                    ),

                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(' share with your classrooms...',style: TextStyle(color: Colors.grey),),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),


                    itemBuilder: (context,index)=>buildPostItem(context: context,postModel:cubit.listPost[index] ),
                    separatorBuilder: (context,index)=>  SizedBox(height: 20,),
                    itemCount: cubit.listPost.length),


              ],
            ),
          ),
        );
      },

    );
  }
  Widget buildPostItem({context,PostModel? postModel})=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mainColor)
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(

                children: [
                  Text('${postModel!.name}',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),),
                  Spacer(),
                 CubitApp.get(context).currentUser.isTeacher!||postModel.email==myEmail? PopupMenuButton(

                      icon: Icon(Icons.more_vert,color: mainColor,),

                      itemBuilder: (context){
                    return deletePost.map(( String e) {
                      return PopupMenuItem<String>(

                        value: e,
                          child:Text(e)
                      );
                    }).toList();
                  }):SizedBox(),

                ],
              ),

              Text('${postModel.date}',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14,color: Colors.grey),),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 1,

                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text('${postModel.text}',style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),),


        ],
      ),
    ),
  );
  List<String>deletePost=['delete'];
}

