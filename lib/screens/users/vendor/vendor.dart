import 'package:flutter/material.dart';
import 'package:harvest/screens/users/vendor/recieved_orders.dart';
import 'package:harvest/util/applocale.dart';

import 'my_products.dart';

class Vendor extends StatefulWidget {
  const Vendor({Key? key}) : super(key: key);

  @override
  _VendorState createState() => _VendorState();
}

class _VendorState extends State<Vendor> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              MyProducts(),
              ReceivedOrders(),
            ],
          ),
        ),
        Container(
          height: 40,
          color: Colors.white,
          child: TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            controller: tabController,
            isScrollable: false,
            unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'TajawalRegular'),
            tabs: [
              Row(
                children: [Text(lang(context, 'myPosts')!), const Icon(Icons.add_box)],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              Row(
                children: [
                  Text(lang(context, 'orders')!),
                  const Icon(
                    Icons.format_list_numbered_rtl,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
