abstract class StateLayout{}
class InitLayoutState extends StateLayout{}
class ChangeBottomNavState  extends StateLayout{}
class CreatePostErrorState extends StateLayout{
  String?error;
  CreatePostErrorState({this.error});
}
class CreatePostLoadingState extends StateLayout{}
class CreatePostSuccessState extends StateLayout{}
class GetPostErrorState extends StateLayout{
  String?error;
  GetPostErrorState({this.error});
}
class GetPostLoadingState extends StateLayout{}
class GetPostSuccessState extends StateLayout{}
class GetStudentErrorState extends StateLayout{
  String?error;
  GetStudentErrorState({this.error});
}
class DeletePostSuccessState extends StateLayout{}
class DeletePostErrorState extends StateLayout{
  String?error;
  DeletePostErrorState({this.error});
}
class GetStudentLoadingState extends StateLayout{}
class GetStudentSuccessState extends StateLayout{}
class ActionButtonQuizState extends StateLayout{}
class DropDownButtonState extends StateLayout{}
class AddQuestionToList extends StateLayout{}
class UploadingQuizErrorState extends StateLayout{
  String?error;
  UploadingQuizErrorState({this.error});
}
class UploadingQuizLoadingState extends StateLayout{}
class UploadingQuizSuccessState extends StateLayout{}
class GetQuizErrorState extends StateLayout{
  String?error;
  GetQuizErrorState({this.error});
}
class GetQuizLoadingState extends StateLayout{}
class GetQuizSuccessState extends StateLayout{}
class DeleteQuizErrorState extends StateLayout{
  String?error;
  DeleteQuizErrorState({this.error});
}
class DeleteQuizLoadingState extends StateLayout{}
class DeleteQuizSuccessState extends StateLayout{}
class OptionSelectState extends StateLayout{}
class AddNumberOfOption extends StateLayout{}
class UploadingStudentAnswerErrorState extends StateLayout{
  String?error;
  UploadingStudentAnswerErrorState({this.error});
}
class UploadingStudentAnswerLoadingState extends StateLayout{}
class UploadingStudentAnswerSuccessState extends StateLayout{}
class GetStudentQuizStateErrorState extends StateLayout{
  String?error;
  GetStudentQuizStateErrorState({this.error});
}
class GetStudentQuizStateSuccessState extends StateLayout{}
class GetStudentAnswerErrorState extends StateLayout{
  String?error;
  GetStudentAnswerErrorState({this.error});
}
class GetStudentAnswerSuccessState extends StateLayout{}
class GetStudentAnswerLoadingState extends StateLayout{}
class GetTokenSuccessState extends StateLayout{}
class GetChatSuccessState extends StateLayout{}
class SendMessageErrorState extends StateLayout{
  String?error;
  SendMessageErrorState({this.error});
}
class SendMessageSuccessState extends StateLayout{}
class UpDateClassErrorState extends StateLayout{
  String?error;
  UpDateClassErrorState({this.error});
}
class UpDateClassLoadingState extends StateLayout{}
class UpDateClassSuccessState extends StateLayout{}

