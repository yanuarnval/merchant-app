import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_app/bloc/event/transaksi_event.dart';
import 'package:merchant_app/bloc/state/transaksi_state.dart';
import 'package:merchant_app/netwotrk/transaksi_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderBloc extends Bloc<TransaksiEvent, TransaksiState> {
  OrderBloc() : super(InitialTransaksiState()) {
    on<TransaksiEvent>((event, emit) async {
      if (event is GetTransaksi) {
        emit(LoadingTransaksiState());
        SharedPreferences sp = await SharedPreferences.getInstance();
        final token = sp.getString('token').toString();
        final merchantId = sp.getString('id').toString();
        try {
          final data = await TransaksiApi().getTransaksi(merchantId, token);
          print(data);
          if (data.isNotEmpty) {
            emit(SuccesTransaksistate(data));
          }
        } catch (e) {
          emit(FailureTransaksiState(e.toString()));
        }
      }
    });
  }
}
