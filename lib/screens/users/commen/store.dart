import 'package:harvest/screens/products/products_taps.dart';
import 'package:harvest/screens/products/meats_nd_milktap.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
  TabController? clientTabController;

  @override
  void initState() {
    clientTabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    clientTabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: TabBar(
                  labelColor: Theme.of(context).colorScheme.secondary,
                  controller: clientTabController,
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'TajawalRegular'),
                  tabs: [
                    Text(lang(context, 'fruits')!),
                    Text(lang(context, 'vegetables')!),
                    Text(lang(context, 'meat')!),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: clientTabController,
                  children: const [
                    Fruits(),
                    Vegetables(),
                    Meats(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
