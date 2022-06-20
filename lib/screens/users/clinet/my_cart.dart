import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/screens/users/commen/tracking_orders.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  Tween<Offset> offset = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  GlobalKey<AnimatedListState> globalKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return StreamBuilder<List<Product>>(
        stream: FB(uid: user.uid).getClientOrders,
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (context, index) {
                  return OrderDetails(
                    product: snap.data![index],
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  lang(context, 'emptyCart')!,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                ),
              );
            }
          } else {
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Image.asset(
                  'assets/loading_card.gif',
                  fit: BoxFit.cover,
                );
              },
            );
          }
        });
  }
}

class OrderDetails extends StatefulWidget {
  final Product product;

  const OrderDetails({Key? key, required this.product}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isExpanded = false;

  double ch = 100, opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: widget.product.orderState == 0 ? 0.3 : 1.0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            ch = ch == 100 ? 200 : 100;
            isExpanded = isExpanded == true ? false : true;
            opacity = opacity == 0.0 ? 1.0 : 0.0;
          });
        },
        child: Stack(
          children: [
            AnimatedContainer(
              width: w,
              height: ch,
              margin: const EdgeInsets.fromLTRB(8, 30, 30, 4),
              decoration: containerRadius(radius: 10),
              duration: const Duration(milliseconds: 400),
              curve: Curves.decelerate,
            ),
            Positioned(
              right: 5,
              top: 0,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(widget.product.url!),
              ),
            ),
            Positioned(
              right: 85,
              top: 45,
              child: Text(
                langCode(context) == 'ar' ? widget.product.nameAR! : widget.product.nameEN ?? '',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            Positioned(
              left: 20,
              top: 45,
              width: w * .35,
              height: 100,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.quantity!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.product.price!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '10.0',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        width: 40,
                        child: Divider(
                          height: 1,
                          color: Colors.black,
                          thickness: 0.5,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${double.parse(widget.product.price!) * double.parse(widget.product.quantity!) + 10.0}  ${widget.product.currency}',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang(context, 'quantity')!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        lang(context, 'price')!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        lang(context, 'deliverPrice')!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(''),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 20,
              width: w * .6,
              child: widget.product.orderState != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.product.orderState! < 50 && isExpanded
                            ? RawMaterialButton(
                                child: Text(
                                  lang(context, 'cancel')!,
                                  style: TextStyle(color: Colors.red[900], fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                                onPressed: () {
                                  FB().cancelOrder(widget.product.orderUID, 0);
                                },
                              )
                            : const SizedBox(),
                        RawMaterialButton(
                          child: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          onPressed: () {
                            setState(() {
                              ch = ch == 100 ? 200 : 100;
                              isExpanded = isExpanded == true ? false : true;
                              opacity = opacity == 0.0 ? 1.0 : 0.0;
                            });
                          },
                        ),
                      ],
                    )
                  : RawMaterialButton(
                      child: Text(
                        lang(context, 'delete')!,
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                      onPressed: () {
                        FB().deleteOrder(widget.product.orderUID, widget.product.vendorUID);
                      },
                    ),
            ),
            isExpanded
                ? Positioned(
                    bottom: 40,
                    left: 40,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.decelerate,
                      opacity: opacity,
                      child: OrderTracker(product: widget.product),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
