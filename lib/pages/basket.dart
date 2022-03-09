import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/basket_card.dart';
import 'package:scorohod_app/widgets/button.dart';

class BasketPage extends StatefulWidget {
  final Color color;
  const BasketPage({Key? key, required this.color}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  Widget build(BuildContext context) {
    var block = BlocProvider.of<OrdersBloc>(context);
    if (block.products.isEmpty) {
      Timer(
          const Duration(milliseconds: 300), () => Navigator.maybePop(context));
    }

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          // elevation: 0,
          foregroundColor: widget.color,
          // expandedHeight: 210,
          title: Text(
            'Корзина',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 15,
          ),
        ),
        if (block.products.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => basketCard(block, index),
                childCount:
                    BlocProvider.of<OrdersBloc>(context).products.length),
          )
      ]),
    );
  }

  Widget basketCard(OrdersBloc block, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        boxShadow: shadow,
        borderRadius: radius,
        color: Colors.white,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.memory(
            base64Decode(block.products[index].image!),
            width: 70,
            height: 70,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    block.products[index].name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  block.products[index].weight,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          if (block.products[index].quantity > 1) {
                            block.products[index].quantity--;
                          } else {
                            BlocProvider.of<OrdersBloc>(context).add(
                                RemoveProductFromBasketPage(
                                    orderElement: block.products[index]));
                          }
                          setState(() {});
                        },
                        child: Image.asset(
                          "assets/button_del_big.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            block.products[index].quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              fontFamily: 'SFUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          block.products[index].quantity++;
                          setState(() {});
                        },
                        child: AddColorButton(color: widget.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  BlocProvider.of<OrdersBloc>(context).add(
                      RemoveProductFromBasketPage(
                          orderElement: block.products[index]));
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15, right: 15),
                  child: Icon(
                    Icons.close,
                    size: 23,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15, right: 15),
                child: Text(
                  (block.products[index].price * block.products[index].quantity)
                          .toInt()
                          .toString() +
                      ' ₽',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
