import 'package:merchant_app/model/product_model.dart';

abstract class ProductsState{}

class InitialProductsState extends ProductsState{

}

class SuccesProductstate extends ProductsState{
  List<ProductModel> produts;

  SuccesProductstate(this.produts);
}

class LoadingProductsState extends ProductsState {

}

class FailureProductsState extends ProductsState{
String msg;

FailureProductsState(this.msg);
}