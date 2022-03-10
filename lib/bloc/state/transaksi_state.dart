import 'package:merchant_app/model/order_model.dart';
import 'package:merchant_app/model/product_model.dart';

abstract class TransaksiState{}

class InitialTransaksiState extends TransaksiState{

}

class SuccesTransaksistate extends TransaksiState{
  List<OrderModel> produts;

  SuccesTransaksistate(this.produts);
}

class LoadingTransaksiState extends TransaksiState {

}

class FailureTransaksiState extends TransaksiState{
String msg;

FailureTransaksiState(this.msg);
}