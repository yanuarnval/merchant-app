import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_app/bloc/event/products_event.dart';
import 'package:merchant_app/bloc/state/products_state.dart';
import 'package:merchant_app/netwotrk/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(InitialProductsState()) {
    on<ProductsEvent>((event, emit) async {
      if (event is Getproducts) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        final token = sp.getString('token').toString();
        final merchantId = sp.getString('id').toString();
        print(merchantId);
        try {
          emit(LoadingProductsState());
          final response = await Products().getProducts(token, merchantId);
          emit(SuccesProductstate(response.reversed.toList()));
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
