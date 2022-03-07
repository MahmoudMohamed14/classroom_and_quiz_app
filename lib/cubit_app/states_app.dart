abstract class StateApp{}
class InitAppState extends StateApp{}
class LoadingCreateClassState extends StateApp{}
class SuccessCreateClassState extends StateApp{}
class ErrorCreateClassState extends StateApp{
  String ?error;
  ErrorCreateClassState({this.error});

}
class LoadingDeleteClassState extends StateApp{}
class SuccessDeleteClassState extends StateApp{}
class ErrorDeleteClassState extends StateApp{
  String ?error;
  ErrorDeleteClassState({this.error});

}
class ActionButtonState extends StateApp{}
class LoadingAddClassToTeacherState extends StateApp{}
class SuccessAddClassToTeacherState extends StateApp{}
class ErrorAddClassToTeacherState extends StateApp{
  String ?error;
  ErrorAddClassToTeacherState({this.error});

}
class GetClassNameSuccessState extends StateApp{}
class GetClassNameErrorState extends StateApp{
  String ?error;
  GetClassNameErrorState({this.error});
}
class GetCurrentUserSuccessState extends StateApp{}
class GetCurrentUserErrorState extends StateApp{
  String ?error;
  GetCurrentUserErrorState({this.error});
}
class GetAllUserSuccessState extends StateApp{}
class GetAllUserErrorState extends StateApp{
  String ?error;
  GetAllUserErrorState({this.error});
}
class AddStudentToClassLoadingState extends StateApp{}
class AddStudentToClassSuccessState extends StateApp{}
class AddStudentToClassErrorState extends StateApp{
  String ?error;
  AddStudentToClassErrorState({this.error});
}
class GetClassErrorState extends StateApp{
  String ?error;
  GetClassErrorState({this.error});
}
class GetClassSuccessState extends StateApp{

}
class GetMyAllClassSuccessState extends StateApp{}
class GetMyAllClassErrorState extends StateApp{
  String ?error;
  GetMyAllClassErrorState({this.error});
}
class DeleteClassFromStudentSuccessState extends StateApp{}
class DeleteClassFromStudentErrorState extends StateApp{
  String ?error;
  DeleteClassFromStudentErrorState({this.error});
}
class DeleteStudentFromClassSuccessState extends StateApp{}
class DeleteStudentFromClassErrorState extends StateApp{
  String ?error;
  DeleteStudentFromClassErrorState({this.error});
}
class GetMyAllClassLoadingState extends StateApp{}
