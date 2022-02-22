abstract class LoginState{}
class LoginInitState extends LoginState{}
class LoginPasswordState extends LoginState{}
class LoginLoadingState extends LoginState{}

class LoginSuccessState extends LoginState{
  String? uId;

  LoginSuccessState({this.uId});
}
class LoginErrorState extends LoginState{
  String?error;
  LoginErrorState({this.error});
}

class GetClassNameSuccessState extends LoginState{}
class GetClassNameErrorState extends LoginState{}
