

abstract class MessageEvent {

}

class PostMessageToFirebase extends MessageEvent {
  String msg;
  String merchantEmail;

  PostMessageToFirebase(this.msg, this.merchantEmail);

}

class GetMessageFromFirebase extends MessageEvent {
  String emailMerchant;

  GetMessageFromFirebase(this.emailMerchant);
}
