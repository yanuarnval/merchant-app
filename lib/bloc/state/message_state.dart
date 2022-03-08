

abstract class MessageState  {

}

class InitialMessageLoadState extends MessageState {}

class SuccesLoadMessageState extends MessageState {
  List msg;
  String uid;
  String uidChatrooms;

  SuccesLoadMessageState(this.msg, this.uid,this.uidChatrooms);

  @override
  String toString() {
    return 'SuccessLoadAllProductState{message: $msg,}';
  }
}

class EmpetyMsgState extends MessageState {

}

class FailureLoadMessageState extends MessageState {
  final String errorMessage;

  FailureLoadMessageState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadProductState{errorMessage: $errorMessage}';
  }
}
