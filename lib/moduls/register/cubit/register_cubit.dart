import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/models/users_model.dart';
import 'package:quizapp/moduls/register/cubit/register_state.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());
  bool? isTeacher;
  static RegisterCubit get(context) {
    return BlocProvider.of(context);
  }
  void radioButton({teacher}){
    isTeacher=teacher;
    emit(IsTeacherState());

  }
  UsersModel? usersModel;



  void registerUser({
    required String name,
    required String email,
    required String password,
    required  bool isTeacher

  }){
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      usersModel= UsersModel(
        name: name,
        email: email,
        password: password,
        id: value.user!.uid,
        isTeacher:isTeacher
      );
      if(CacheHelper.getData(key: 'email')==null)myEmail=email;
     CacheHelper.putData(key: 'email', value: email);
      uId=value.user!.uid;
      createUser(usersModel: usersModel,);

    }).catchError((error){
      print('error Register'+error.toString());
      emit(RegisterErrorState(error: error.toString()));



    });
  }
  void createUser({
    UsersModel? usersModel,

  }){

    FirebaseFirestore.instance
        .collection('users')
        .doc(usersModel!.email!)
        .set(usersModel.toMap()).then((value) {

           emit(CreateUserSuccessState( ));

    }).catchError((error){
      print('error create user'+error.toString());
      emit(CreateUserErrorState(error: error.toString()));


    });


  }

  // void postCassNam ({
  //   required String className
  // }){
  //   FirebaseFirestore.instance.collection('className').doc(className).set({
  //
  //
  //   }).then((value) {
  //     constClassName=className;
  //
  //     emit(PostClassNameSuccessState()) ;
  //
  //
  //   }).catchError((error){
  //
  //    emit(PostClassNameErrorState(error: error.toString())) ;
  //
  //   });
  //
  // }


}