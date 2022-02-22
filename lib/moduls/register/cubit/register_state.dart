abstract class RegisterStates{}
class RegisterInitState extends RegisterStates{}
class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{


}
class RegisterErrorState extends RegisterStates{
  String?error;
  RegisterErrorState({this.error});
}
class CreateUserLoadingState extends RegisterStates{}

class CreateUserSuccessState extends RegisterStates{


}
class CreateUserErrorState extends RegisterStates{
  String?error;
  CreateUserErrorState({this.error});
}
class PostClassNameSuccessState extends RegisterStates{


}
class PostClassNameErrorState extends RegisterStates{
  String?error;
  PostClassNameErrorState({this.error});
}
class IsTeacherState extends RegisterStates{}