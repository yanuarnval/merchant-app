import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_event.dart';
import '../model/user_state.dart';

class ProfilBloc extends Bloc<UserEvent, UserState> {
  ProfilBloc() : super(InitialUserState()) {
    on<UserEvent>((event, emit) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String uid = preferences.get('uid').toString();
      if (event is getUserFromFirestore) {
        print('getfirestore $uid');
        final _usersStream =
        FirebaseFirestore.instance.collection('users').doc(uid);
        await _usersStream.get().then(
              (value) =>
              emit(
                SuccesLoadUserState(
                    value['email'], value['name'], value['photourl']),
              ),
        );
      }

      if (event is getUserByEmailFirestore) {
        final _usersStream =
        FirebaseFirestore.instance.collection('users');
        await _usersStream.get().then((value) {
          for (int i = 0; i < value.size; i++) {
            if (value.docs.elementAt(i)['email'] == event.email) {
              emit(SuccesLoadUserState(value.docs.elementAt(i)['email'],
                  value.docs.elementAt(i)['name'],
                  value.docs.elementAt(i)['photourl']));
            }
          }
        });
      }
    });
  }
}
