class MessageModel {
  String created;
  String sender;
  String msg;

  MessageModel(this.created, this.sender, this.msg);

  factory MessageModel.fromJson(Map<String, dynamic> msg) {
    return MessageModel(msg['created'], msg['sender'], msg['msg']);
  }
}
