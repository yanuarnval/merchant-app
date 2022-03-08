import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_app/bloc/state/chat_users_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event/chat_users_event.dart';

class ChatUsersBloc extends Bloc<ChatUsersEvent, ChatUsersState> {
  ChatUsersBloc() : super(InitialLoadChatUsersState()) {
    on<ChatUsersEvent>(
      (event, emit) async {
        if (event is GetUsersList) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String uid = preferences.get('uid').toString();
          final coll = FirebaseFirestore.instance.collection('users');
          final doc = await coll.doc(uid).get();
          List users = doc.data()!['chatrooms'];

          if (users.isEmpty) {
            emit(EmpetyChatState());
          } else {
            List UsersData = [];
            await coll.get().then((value) async {
              for (int j = 0; j < users.length; j++) {
                for (int i = 0; i < value.size; i++) {
                  if (value.docs.elementAt(i)['email'] == users[j]['email']) {
                    UsersData.add({
                      "name": value.docs.elementAt(i).data()['name'],
                      'uidchat': users[j]['uidchat'],
                      'photourl': users[j]['photourl'],
                      'email':users[j]['email']
                    });
                  }
                }
              }
            });
            emit(SuccesLoadChatUsersState(UsersData));
          }
        }
      },
    );
  }
}
