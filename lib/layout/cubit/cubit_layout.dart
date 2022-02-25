import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/models/post_model.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/student_model.dart';
import 'package:quizapp/moduls/home_work/home_work.dart';
import 'package:quizapp/moduls/people/people.dart';
import 'package:quizapp/moduls/posts/posts_screen.dart';
import 'package:quizapp/shared/constant/constant.dart';

class CubitLayout extends Cubit<StateLayout> {

  CubitLayout() : super(InitLayoutState());
  ClassRoom? classRoomModel;
  String? classId;
  int index=0;
  List<Widget> listWidget=[postScreen(),HomeWork(),PeopleScreen()];
  List<String> listTitle=[];
  List<Map<String,dynamic>> questionList=[];
  bool isActionOpen=true;
  bool isMulitpleChoice=true;

  late QuestionModel questionModel;
  void addQuestionToList({required String question,required String option1,required String option2, String? option3, String? option4}){
    questionModel=QuestionModel(question: question,optoin1: option1,optoin2: option2,optoin3:isMulitpleChoice? option3:'null',optoin4:isMulitpleChoice? option4:'null');
    questionList.add(questionModel.toMap());
    emit(AddQuestionToList());
  }
  void dropDownBotton({ ischoice}){
    isMulitpleChoice=ischoice;
    emit(DropDownButtonState ());
  }
  void actionButtonQuiz({required bool isAction}){
    isActionOpen=isAction;
    emit(ActionButtonQuizState());

  }

  void setClassRoomAndId(ClassRoom classRoom,String ?classid){
    classRoomModel=classRoom;
    classId=classid;
    getPost();
  }


  static CubitLayout get(context) {
    return BlocProvider.of(context);
  }
  List<String> optionSelectList=[];
  void addNumberOfOption({int ?number}){
    optionSelectList=[];
    for(int i=0;i<number!;i++){
      optionSelectList.add('empty');

    }
    emit(AddNumberOfOption ());

  }

  void selectOption({required String option,required int index}){
   optionSelectList[index]=option;

    emit(OptionSelectState());


  }
  void  changeBottomNav({required int index})
  {



     this. index = index;


  getAllStudent();


      emit( ChangeBottomNavState());



  }
  void createPost({
   required String text,required String date

}){
    var Postmodel=
    PostModel(name: globalUserModel!.name,email:globalUserModel!.email,date: date ,text: text);
    emit(CreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.className!)
        .collection('posts').add(Postmodel.toMap()).then((value) {
           getPost();
          emit(CreatePostSuccessState());

    }).catchError((onError){
      emit(CreatePostErrorState(error: onError.toString()));

    });

  }
  List<PostModel> listPost=[];
  void getPost(){
    listPost=[];

    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.className!)
        .collection('posts')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            listPost.add(PostModel.fromJson(json: element.data()));
          });
      emit(GetPostSuccessState());

    }).catchError((onError){
      emit(GetPostErrorState(error: onError.toString()));

    });

  }
  List<StudentModel> listStudent=[];
  void getAllStudent(){
    listStudent=[];
    emit(GetStudentLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.className!)
        .collection('Students')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        listStudent.add(StudentModel.fromJson(json: element.data()));
      });
      emit(GetStudentSuccessState());

    }).catchError((onError){
      emit(GetStudentErrorState(error: onError.toString()));

    });

  }
  void uploadQuiz({required QuizModel quizModel,context}){
    emit(UploadingQuizLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.className)
        .collection('quiz').add(quizModel.toMap()).then((value) {
          questionList=[];
          getQuiz();
          Navigator.pop(context);



    }).catchError((onError){
      emit(UploadingQuizErrorState(error: onError.toString()));
      print('error her'+onError.toString());

    });
  }
  List<QuizModel>quizList=[];
  List<String>quizIdList=[];
  void getQuiz(){
    quizList=[];
    quizIdList=[];
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.className)
        .collection('quiz').get().then((value) {
          value.docs.forEach((element) {
            quizList.add(QuizModel.fromJson(json: element.data()));
            quizIdList.add(element.id);


          });


      emit(GetQuizSuccessState());

    }).catchError((onError){
      emit(GetQuizErrorState(error: onError.toString()));
      print('error her for get quiz'+onError.toString());

    });
  }
}