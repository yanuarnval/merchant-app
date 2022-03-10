import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:merchant_app/bloc/event/login_event.dart';
import 'package:merchant_app/bloc/state/login_state.dart';
import 'package:merchant_app/netwotrk/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState()) {
    on<LoginEvent>((event, state) async {
      if (event is PostLogin) {
        emit(LoadingLoginState());
        final users = FirebaseFirestore.instance.collection('users');
        QuerySnapshot<Map<String, dynamic>> userList = await users.get();
        try {
          await UserApi()
              .PostLogin(event.email, event.password)
              .then((value) async {
            for (int i = 0; i < userList.docs.length; i++) {
              if (userList.docs
                  .elementAt(i)
                  .data()
                  .containsValue(event.email)) {
                final uid = userList.docs.elementAt(i).id;
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setString('id', value.idUser);
                sp.setString('token', value.token);
                sp.setString('uid', uid);
                emit(SuccesLoginState());
              }
            }

          });
        } catch (e) {
          print(e);
          emit(FailureLoginState(e.toString()));
        }
      }
    });
  }
}
