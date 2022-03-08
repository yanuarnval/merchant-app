abstract class ChatUsersState {}

class InitialLoadChatUsersState extends ChatUsersState {}

class EmpetyChatState extends ChatUsersState {}

class SuccesLoadChatUsersState extends ChatUsersState {
  final List chatrooms;

  SuccesLoadChatUsersState(this.chatrooms);
}

class FailureLoadChatUsersState extends ChatUsersState {
  final String errorMessage;

  FailureLoadChatUsersState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadProductState{errorMessage: $errorMessage}';
  }
}
