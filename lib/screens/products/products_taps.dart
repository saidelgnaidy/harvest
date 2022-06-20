import 'package:flutter/material.dart';
import 'package:harvest/util/util.dart';
import 'package:harvest/util/database.dart';

class Fruits extends StatelessWidget {
  const Fruits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
        stream: FB().fruitsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyGridView(products: snapshot.data);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class MeatAndChick extends StatelessWidget {
  const MeatAndChick({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: FB().meatChickenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Milk extends StatelessWidget {
  const Milk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: FB().milkStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SeaFood extends StatelessWidget {
  const SeaFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: FB().seafoodStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Vegetables extends StatelessWidget {
  const Vegetables({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: FB().vegetablesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
