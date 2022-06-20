import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/util.dart';

class OrderTracker extends StatelessWidget {
  final Product? product;

  const OrderTracker({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: w * .7,
          height: 50,
        ),
        Positioned(
          top: 10,
          child: Container(
            width: w * .7,
            height: 4,
            decoration: containerRadius(radius: 10).copyWith(color: Theme.of(context).colorScheme.secondary.withOpacity(.4)),
          ),
        ),
        AnimatedPositioned(
          top: 4,
          left: product!.orderState == 25
              ? w * .05
              : product!.orderState == 50
                  ? w * .2
                  : product!.orderState == 75
                      ? w * .34
                      : product!.orderState == 100
                          ? w * .7 - 15
                          : 0,
          duration: const Duration(milliseconds: 1000),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          width: w * .7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Opacity(
                opacity: product!.orderState == 25 ? 1.0 : .5,
                child: Text(
                  lang(context, 'received')!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 10),
                  textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                ),
              ),
              Opacity(
                opacity: product!.orderState == 50 ? 1.0 : .5,
                child: Text(
                  lang(context, 'ready')!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 10),
                  textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                ),
              ),
              Opacity(
                opacity: product!.orderState == 75 ? 1.0 : .5,
                child: Text(
                  lang(context, 'onTheWay')!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 10),
                  textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                ),
              ),
              Opacity(
                opacity: product!.orderState == 100 ? 1.0 : .5,
                child: Text(
                  lang(context, 'delivered')!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 10),
                  textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
