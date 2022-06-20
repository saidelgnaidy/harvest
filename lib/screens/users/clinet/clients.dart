import 'package:flutter/material.dart';
import 'package:harvest/screens/users/clinet/my_cart.dart';
import 'package:harvest/screens/users/commen/store.dart';
import 'package:harvest/util/applocale.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> with SingleTickerProviderStateMixin {
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
              StorePage(),
              MyCart(),
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
            physics: const ScrollPhysics().parent,
            unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.6),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'TajawalRegular'),
            tabs: [
              Row(
                children: [Text(lang(context, 'store')!), const Icon(Icons.store)],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              Row(
                children: [
                  Text(lang(context, 'myOrders')!),
                  const Icon(
                    Icons.shopping_cart,
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
