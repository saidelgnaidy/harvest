import 'package:flutter/material.dart';
import 'package:harvest/screens/products/products_taps.dart';
import 'package:harvest/util/applocale.dart';

class Meats extends StatefulWidget {
  const Meats({Key? key}) : super(key: key);

  @override
  _MeatsState createState() => _MeatsState();
}

class _MeatsState extends State<Meats> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
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
        Container(
          height: 40,
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
          child: TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            controller: tabController,
            unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'TajawalRegular'),
            tabs: [
              Text(lang(context, 'seafood')!),
              Text(lang(context, 'meats')!),
              Text(lang(context, 'milk')!),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              SeaFood(),
              MeatAndChick(),
              Milk(),
            ],
          ),
        )
      ],
    );
  }
}
