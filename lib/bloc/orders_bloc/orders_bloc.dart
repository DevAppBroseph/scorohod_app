import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders.dart';
import 'package:scorohod_app/objects/order_element.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  List<OrderElement> products = [];
  double totalPrice = 0;
  double deliveryPrice = 0;
  int servicePrice = 0;
  int orderId = 0;
  String distance = '';
  bool city = false;

  OrdersBloc() : super(OrderIdle());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is AddProduct) {
      yield OrderLoading();

      if (products
          .where((element) => element.id == event.orderElement.id)
          .toList()
          .isNotEmpty) {
        var product = products
            .where((element) => element.id == event.orderElement.id)
            .toList()
            .first;
        product.quantity = event.orderElement.quantity;
        product.price = event.orderElement.price;
        // products.add(event.orderElement);
      } else {
        products.add(event.orderElement);
      }

      totalPrice = 0;

      for (var element in products) {
        totalPrice += element.price;
      }
      for (var product in products) {
        if (product.quantity == 0) {
          products.removeWhere((element) => element.id == product.id);
        }
      }

      yield OrderIdle();
    }

    if (event is AddDeliveryPrice) {
      yield OrderLoading();

      // if (deliveryPrice == 0 && servicePrice == 0) {
      deliveryPrice = event.price;
      servicePrice = event.servicePrice;
      // }

      city = event.city;
      distance = event.distance;

      yield OrderIdle();
    }

    if (event is EditProduct) {
      yield OrderLoading();

      products.removeAt(event.index);
      products.insert(event.index, event.orderElement);

      totalPrice = 0;

      for (var element in products) {
        totalPrice += element.quantity * element.price;
      }

      yield OrderIdle();
    }

    if (event is RemoveProductFromBasketPage) {
      yield OrderLoading();

      List items = products
          .where((element) => element.id == event.orderElement.id)
          .toList();
      // if (items.isNotEmpty && items.first.quantity > 1) {
      //   products
      //       .where((element) => element.id == event.orderElement.id)
      //       .toList()
      //       .first
      //       .quantity -= event.orderElement.quantity;
      // } else {
      products.remove(event.orderElement);
      // }
      totalPrice = 0;
      for (var element in products) {
        totalPrice += element.basePrice * element.quantity;
      }

      yield OrderIdle();
    }

    if (event is RemoveProductFromHomePage) {
      yield OrderLoading();

      var currentProduct = event.product;

      if (products.isNotEmpty &&
          products.last.quantity > 1 &&
          products.contains(currentProduct)) {
        products.firstWhere(
            (element) => element.id == currentProduct.nomenclatureId);
      } else {
        products.remove(currentProduct);
      }

      totalPrice = 0;

      for (var element in products) {
        totalPrice -= element.price;
      }

      yield OrderIdle();
    }

    if (event is RemoveProducts) {
      yield OrderLoading();

      products = [];

      deliveryPrice = 0;
      servicePrice = 0;

      totalPrice = 0;

      yield OrderIdle();
    }
  }
}
