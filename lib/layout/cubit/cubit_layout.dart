

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/answer_student_model.dart';
import 'package:quizapp/models/chat_model.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/models/post_model.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/models/quiz_model.dart';
import 'package:quizapp/models/student_model.dart';
import 'package:quizapp/moduls/home_work/home_work.dart';
import 'package:quizapp/moduls/people/people.dart';
import 'package:quizapp/moduls/posts/posts_screen.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';
import 'package:quizapp/shared/network/remotely/dio_helper.dart';
import 'package:quizapp/shared/translate/applocale.dart';

class CubitLayout extends Cubit<StateLayout> {

  CubitLayout() : super(InitLayoutState());
  ClassRoom? classRoomModel;
  String? classId;
  int index=0;
  List<String>titleList (context)=>[
    '${getLang(context, "posts")}',
    '${getLang(context, "quiz_name")}',
    '${getLang(context, "member")}'
  ];
  int indexForQuiz=0;
  List<Widget> listWidget=[postScreen(),HomeWork(),PeopleScreen()];
  List<String> listTitle=[];
  List<Map<String,dynamic>> questionList=[];
  bool isActionOpen=true;
  bool isMulitpleChoice=true;
  bool isQuizGame=false;
  void  changeBottomNavForQuiz({required int index})
  {



    this. indexForQuiz = index;


    emit( ChangeBottomNavState());



  }

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
  void dropDownBottonQuizGame({ isQuiz}){
    isQuizGame=isQuiz;
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
  List<int> counterList=[];
  void addNumberOfOption({int ?number}){
    optionSelectList=[];
    counterList=[];
    for(int i=0;i<number!;i++){
      optionSelectList.add('empty');
      counterList.add(0);

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
        .doc(classRoomModel!.code!)
        .collection('posts').add(Postmodel.toMap()).then((value) {
           getPost();
           DioHelper.postNotification(to: '/topics/${classRoomModel!.code!}',
               title: classRoomModel!.className!,
               body: '${globalUserModel!.name} post in class',
             data: {'addToClaas':'false','deleteClass':'false','className':'', "type": "order",
               "id": "87",
               "click_action": "FLUTTER_NOTIFICATION_CLICK"}
               );
          emit(CreatePostSuccessState());

    }).catchError((onError){
      emit(CreatePostErrorState(error: onError.toString()));

    });

  }
  List<PostModel> listPost=[];
  List<String> listPostId=[];
  void getPost(){
    listPost=[];
    listPostId=[];

    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.code!)
        .collection('posts')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            listPost.add(PostModel.fromJson(json: element.data()));
            listPostId.add(element.id);
          });
      emit(GetPostSuccessState());

    }).catchError((onError){
      emit(GetPostErrorState(error: onError.toString()));

    });

  }
  List<StudentModel> listStudent=[];
  void getAllStudent({String? code,bool formOut=false}){
    listStudent=[];
    emit(GetStudentLoadingState());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(formOut?code:classRoomModel!.code!)
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
        .doc(classRoomModel!.code)
        .collection('quiz')
        .add(quizModel.toMap()).then((value) {
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
        .doc(classRoomModel!.code)
        .collection('quiz').get().then((value) {
          value.docs.forEach((element) {
            quizList.add(QuizModel.fromJson(json: element.data()));
            quizIdList.add(element.id);
            //get is test answer for this quiz? if he sign in anther device
           element.reference.
           collection('studentAnswer').
           doc(myEmail).
           get().then((value) {
             if(value.data()!=null) {
               CacheHelper.putData(
                   key: element.id + globalUserModel!.email!, value: true);
               print('get anser ');
             }
           }).
           catchError((onError){
             print('error get answer '+onError.toString());
           });

          });




      emit(GetQuizSuccessState());

    }).catchError((onError){
      emit(GetQuizErrorState(error: onError.toString()));
      print('error her for get quiz'+onError.toString());

    });
  }
  AnswerStudentModel? answerStudentModel;
  void upLoadingStudentAnswer({context, required String quizId,required myAnswer}){
   answerStudentModel=AnswerStudentModel(name: globalUserModel!.name,email:globalUserModel!.email,myAnswer: myAnswer );
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.code)
        .collection('quiz').doc(quizId)
        .collection('studentAnswer').doc(globalUserModel!.email)
        .set(answerStudentModel!.toMap()).then((value) {

            Navigator.pop(context);
          emit(UploadingStudentAnswerSuccessState());
    }).catchError((onError){
      emit(UploadingStudentAnswerErrorState(error: onError.toString()));
    });

  }
  List<AnswerStudentModel>listAnswerStudentModel=[];
  void getStudentAnswer({required String quizId}){

    listAnswerStudentModel=[];
    emit(GetStudentAnswerLoadingState ());
    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.code)
        .collection('quiz')
        .doc(quizId)
        .collection('studentAnswer').
       get().then((value) {

         value.docs.forEach((element) {
           listAnswerStudentModel.add(AnswerStudentModel.fromJson(json: element.data()));
         });


      emit(GetStudentAnswerSuccessState ());
    }).catchError((onError){
      emit(GetStudentAnswerErrorState(error: onError.toString()));
    });

  }
  void deletePost(postId){



    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.code!)
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
          emit(DeletePostSuccessState());


    }).catchError((onError){
      emit(DeletePostErrorState(error: onError.toString()));

    });

  }
  void deleteQuiz({required String quizId}){


    FirebaseFirestore.instance
        .collection('Classrooms')
        .doc(classRoomModel!.code)
        .collection('quiz')
        .doc(quizId).delete().then((value) {
      FirebaseFirestore.instance
          .collection('Classrooms')
          .doc(classRoomModel!.code)
          .collection('quiz')
          .doc(quizId).collection('studentAnswer').snapshots().forEach((element) {
        for (QueryDocumentSnapshot snapshot in element.docs) {
          snapshot.reference.delete();
        }
      });
      emit(DeleteQuizSuccessState());



    }).catchError((onError){
      emit(DeleteQuizErrorState(error: onError.toString()));
      print('Delete error her'+onError.toString());

    });
  }
  String? token;
  void getToken({required String email}){

    FirebaseFirestore.instance.collection('token').doc(email).get().then((value) {
      token=value.data()!['token'];
      emit(GetTokenSuccessState());

    });

  }
  List<ChatModel> messageModel=[];
  void getMessage({
    required String receiverEmail,
  }){
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(globalUserModel!.email)
        .collection('chat')
        .doc(receiverEmail)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messageModel=[];
      event.docs.forEach((element) {
        messageModel.add(ChatModel.fromJson(element.data()));
      });
      emit(GetChatSuccessState());



    });

  }
  void sendMessage({
    required String receiverEmail,
    required String dateTime,
    required String ?text
  }){
    ChatModel chatModel=ChatModel(
        sendEmail: globalUserModel!.email,
        text: text,
        dateTime: dateTime,
        receiverEmail: receiverEmail
    );
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(globalUserModel!.email)
        .collection('chat')
        .doc(receiverEmail)
        .collection('message')
        .add(chatModel.toMap()).then((value) {
      emit(SendMessageSuccessState());
    }).catchError((onError){
      print(onError.toString());

      emit(SendMessageErrorState());
    });

    FirebaseFirestore
        .instance
        .collection('users')
        .doc(receiverEmail)
        .collection('chat')
        .doc(globalUserModel!.email)
        .collection('message')
        .add(chatModel.toMap()).then((value) {
      emit(SendMessageSuccessState());
    }).catchError((onError){

      print(onError.toString());
      emit(SendMessageErrorState());
    });

  }
  Future updateClassRoom({name,subject})async{
    emit(UpDateClassLoadingState());
  await FirebaseFirestore.instance.collection('Classrooms')
        .doc(classRoomModel!.code).update({'className':name,'subject':subject}).then((value) {
      FirebaseFirestore.instance.collection('users')
          .doc(classRoomModel!.teacherEmail)
          .collection('Classrooms')
          .doc(classRoomModel!.code).update({'className':name,'subject':subject}).then((value) {

      }).catchError((onError){
        print(onError.toString());
      });



      listStudent.forEach((element) {
            FirebaseFirestore.instance.collection('users')
                .doc(element.studentEmail)
                .collection('Classrooms')
                .doc(classRoomModel!.code).update({'className':name,'subject':subject}).then((value) {

            }).catchError((onError){
              print(onError.toString());
              emit(UpDateClassErrorState());
            });


          });
      emit(UpDateClassSuccessState());

        }).catchError((onError){
          print(onError.toString());
          emit(UpDateClassErrorState());
    });

  }
  void updateClassfromStudent({name,subject,email}){

  }
}