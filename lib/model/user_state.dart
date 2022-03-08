abstract class UserState {}

class InitialUserState extends UserState {}

class SuccesLoadUserState extends UserState {
  String name;
  String email;
  String photourl;

  SuccesLoadUserState(this.email, this.name, this.photourl);
}

class FailureLoadUserState extends UserState {
  final String errorMessage;

  FailureLoadUserState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadProductState{errorMessage: $errorMessage}';
  }
}
