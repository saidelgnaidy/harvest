import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/screens/users/commen/tracking_orders.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';

class ReceivedOrders extends StatefulWidget {
  const ReceivedOrders({Key? key}) : super(key: key);

  @override
  _ReceivedOrdersState createState() => _ReceivedOrdersState();
}

class _ReceivedOrdersState extends State<ReceivedOrders> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final User user = Provider.of<User>(context);
    return StreamBuilder<List<Product>>(
      stream: FB(uid: user.uid).getReceivedOrders,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.isNotEmpty) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: 150,
                          margin: const EdgeInsets.fromLTRB(8, 4, 30, 4),
                          decoration: containerRadius(radius: 10),
                        ),
                        Positioned(
                          right: 5,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              snap.data![index].url!,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 100,
                          top: 15,
                          child: Text(
                            langCode(context) == 'ar' ? snap.data![index].nameAR! : snap.data![index].nameEN ?? '',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                            textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                          ),
                        ),
                        Positioned(
                          right: 100,
                          top: 45,
                          child: Text(
                            snap.data![index].clientAddress!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 15,
                          width: size.width * .35,
                          height: 100,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snap.data![index].quantity!,
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snap.data![index].price!,
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
                                    '${double.parse(snap.data![index].price!) * double.parse(snap.data![index].quantity!) + 10.0}  ${snap.data![index].currency}',
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
                          bottom: 5,
                          left: 40,
                          child: OrderTracker(product: snap.data![index]),
                        )
                      ],
                    );
                  },
                ),
              ],
            );
          } else {
            return Text(
              lang(context, 'noPosts')!,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
