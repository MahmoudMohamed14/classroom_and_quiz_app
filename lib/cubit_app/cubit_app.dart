import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/states_app.dart';
import 'package:quizapp/models/class_room_model.dart';
import 'package:quizapp/models/student_model.dart';
import 'package:quizapp/models/users_model.dart';
import 'package:quizapp/shared/constant/constant.dart';

class CubitApp extends Cubit<StateApp> {
  CubitApp() : super(InitAppState());
  bool isActionOpen=true;

  static CubitApp get(context){return BlocProvider.of(context);}
  void init(){
    getClassName();
    getCurrentUser();
    getMyAllClassRoom();
    getAllUser();
  }
  void createClass({required ClassRoom classRoom}){
    emit(LoadingCreateClassState());
    FirebaseFirestore.instance.collection('Classrooms')
        .doc(classRoom.className)
        .set(classRoom.toMap()).then((value)  {
      addClassRoomToTeacherAndCurrentUser(classRoom.toMap());
      getClassName();


      emit(SuccessCreateClassState());

    }).catchError((onError){
      emit(ErrorCreateClassState(error: onError));
    });
  }
  void actionButton({required bool isAction}){
    isActionOpen=isAction;
    emit(ActionButtonState());

  }
  void addClassRoomToTeacherAndCurrentUser(Map<String,dynamic> map,{String? studentName,String?studentEmail,bool isteacher=false}){
emit(AddStudentToClassLoadingState());
 FirebaseFirestore.instance.collection('users')
    .doc(isteacher ?studentEmail:myEmail)
    .collection('Classrooms')
     .doc(map['className']).set(map).then((value)  {
 if(!currentUser.isTeacher!||isteacher){
   addStudentToClassRoom(className: map['className'],studentEmail:isteacher ?studentEmail!:currentUser.email!,studentName: isteacher ?studentName!:currentUser.name!);

 }else{
   getMyAllClassRoom();
 }




}).catchError((onError){
emit(ErrorAddClassToTeacherState(error: onError));
});

}
  void getClassName(){
  listClassName=[];
  FirebaseFirestore.instance.collection('Classrooms').get()
      .then((value) {
    value.docs.forEach((element) {
     listClassName.add(element.reference.path.split('/').last);



    });
    emit(GetClassNameSuccessState());
    print('list+ $listClassName');



  }).catchError((error){
    print('erroe  '+error.toString());
    emit(GetClassNameErrorState(error: error.toString()));
  });

}
  late UsersModel currentUser;
  void getCurrentUser(){
    FirebaseFirestore.instance.collection('users').doc(myEmail).get().then((value) {
      currentUser=UsersModel.fromJson(json: value.data()!);
      globalUserModel=UsersModel.fromJson(json: value.data()!);
      isTeacher=value.data()!['isTeacher'];
      print('istecher = ${isTeacher}');
      emit(GetCurrentUserSuccessState());

    }).catchError((onError){
      print('get currentuser error:'+onError.toString());
      emit(GetCurrentUserErrorState(error: onError.toString()));
    });
}
List<UsersModel>allUser=[];
  void getAllUser(){
    allUser=[];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            allUser.add(UsersModel.fromJson(json:element.data() ));

          });
          print('all user lenth = ${allUser.length}');

      emit(GetAllUserSuccessState());

    }).catchError((onError){
      print('get All user error:'+onError.toString());
      emit(GetAllUserErrorState(error: onError.toString()));
    });
  }

  void getClass({required String className}){
  FirebaseFirestore.instance
      .collection('Classrooms')
      .doc(className)
      .get()
      .then((value) {
  if(!currentUser.isTeacher!)  {
    addClassRoomToTeacherAndCurrentUser(value.data()!);

  }
  emit(GetClassSuccessState());



  }).catchError((onError){
    print('get Class error'+onError.toString());
    emit(GetClassErrorState(error: onError.toString()));
  });

}
  void addStudentToClassRoom({ required String className,required String studentName,required String studentEmail})
   {
     StudentModel studentModel= StudentModel(studentEmail: studentEmail,studentName: studentName);

  FirebaseFirestore.instance.collection('Classrooms')
      .doc(className)
      .collection('Students')
      .doc(studentEmail)
      .set(studentModel.toMap())
      .then((value) {
    getMyAllClassRoom();

   emit(AddStudentToClassSuccessState ());

  }).catchError((onError){
    print('add student to classrooms  error'+onError.toString());
    emit(AddStudentToClassErrorState(error: onError.toString()));
  });

}
List<ClassRoom>myClass=[];
  List<String>myClassId=[];
 void getMyAllClassRoom(){
   myClass=[];
   myClassId=[];
   emit(GetMyAllClassLoadingState());
  FirebaseFirestore.instance.collection('users')
      .doc(myEmail)
      .collection('Classrooms')
      .get()
      .then((value){
      value.docs.forEach((element) {
        myClassId.add(element.id);
        myClass.add(ClassRoom.fromJson(json: element.data()));
        emit(GetMyAllClassSuccessState());
      });

        }).catchError((onError){
    print('get my all classrooms  error '+onError.toString());
          emit(GetMyAllClassErrorState(error: onError.toString()));

  });




}
void deleteClassRoomFromStudent({required String className,String? studentEmail}){

  FirebaseFirestore.instance.collection('users')
      .doc(currentUser.isTeacher!?studentEmail:myEmail)
      .collection('Classrooms')
      .doc(className)
      .delete()
      .then((value) {
    getMyAllClassRoom();
        emit(DeleteClassFromStudentSuccessState());


  }).catchError((onError){
    emit(DeleteClassFromStudentErrorState(error: onError));

  });

}
  void deleteStudentToClassRoom({ required String className,required String studentEmail})
  {

    FirebaseFirestore.instance.collection('Classrooms')
        .doc(className)
        .collection('Students')
        .doc(studentEmail)
        .delete()
        .then((value) {

      emit(DeleteStudentFromClassSuccessState());

    }).catchError((onError){
      print('add student to classrooms  error'+onError.toString());
      emit(DeleteStudentFromClassErrorState(error: onError.toString()));
    });

  }

}

