import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_app/bloc/state/message_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'event/message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  bool chatIsEmpety = true;
  String uidChatrooms = '';

  MessageBloc() : super(InitialMessageLoadState()) {
    on<MessageEvent>((event, emit) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String uid = preferences.get('uid').toString();
      final _usersStream = FirebaseFirestore.instance.collection('users');
      final fChatrooms = FirebaseFirestore.instance.collection('chatrooms');

      final myEmail = await _usersStream
          .doc(uid)
          .get()
          .then((value) => value['email'].toString());
      if (event is PostMessageToFirebase) {
        if (chatIsEmpety) {
          fChatrooms.add({
            'message': [
              {'created': '110222', 'sender': uid, 'msg': event.msg}
            ]
          }).then((Rvalue) {
            chatIsEmpety = false;
            _usersStream.doc(uid).update({
              "chatrooms": FieldValue.arrayUnion([
                {"email": event.merchantEmail, "uidchat": Rvalue.id}
              ])
            });
            _usersStream.get().then((value) {
              for (int i = 0; i < value.size; i++) {
                if (value.docs
                    .elementAt(i)
                    .data()
                    .containsValue(event.merchantEmail)) {
                  _usersStream.doc(value.docs.elementAt(i).id).update({
                    "chatrooms": FieldValue.arrayUnion([
                      {"email": myEmail, "uidchat": Rvalue.id,}
                    ])
                  });
                  _usersStream.doc(uid).get().then((value) =>
                      getMsg(value['chatrooms'], event.merchantEmail, uid));
                }
              }
            });
          });
        } else {
          fChatrooms.doc(uidChatrooms).update({
            'message': FieldValue.arrayUnion([
              {'created': 'time', 'sender': uid, 'msg': event.msg}
            ])
          });
        }
      }
      if (event is GetMessageFromFirebase) {
        print('getfirestore event GetMessage');

        await _usersStream.doc(uid).get().then((value) =>
            (cekUserChatrooms(value['chatrooms'], event.emailMerchant)
                ? getMsg(value['chatrooms'], event.emailMerchant, uid)
                : emit(EmpetyMsgState())));
      }
    });
  }

  bool cekUserChatrooms(List Data, String email) {
    for (int i = 0; i < Data.length; i++) {
      if (Data[i]['email'] == email) {
        uidChatrooms = Data[i]['uidchat'];
        chatIsEmpety = false;
        print('get false');
        return true;
      }
    }
    print('get true');
    chatIsEmpety = true;
    return false;
  }

  void getMsg(List Data, String email, String uid) {
    /*
    {
    'name':zxcyyt
    'uidchat':zxcasdwwee
    }
     */
    print(email);
    for (int i = 0; i < Data.length; i++) {
      if (Data[i]['email'] == email) {
        uidChatrooms = Data[i]['uidchat'];
      }
    }
    print(uidChatrooms);
    final _chatStream =
        FirebaseFirestore.instance.collection('chatrooms').doc(uidChatrooms);
    _chatStream.get().then((value) {
      emit(SuccesLoadMessageState(value['message'], uid, uidChatrooms));
    });
  }
}
