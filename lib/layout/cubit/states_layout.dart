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
class OptionSelectState extends StateLayout{}
class AddNumberOfOption extends StateLayout{}