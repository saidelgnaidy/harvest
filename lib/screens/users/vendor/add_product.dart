import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? selectedProduct, productType, currency, price, _currency, address;
  int? index;
  Product? postedProduct;
  bool posting = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final User user = Provider.of<User>(context);

    buildExtra(BuildContext context) {
      switch (index) {
        case 0:
          return FutureBuilder<List<Product>>(
              future: FB().getFruits(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'fruits'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product;
                      for (var element in snapshot.data!) {
                        if (element.nameEN == product || element.nameAR == product) {
                          postedProduct = element;
                        }
                      }
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              });
        case 1:
          return FutureBuilder<List<Product>>(
              future: FB().getVegetables(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'vegetables'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product;
                      for (var element in snapshot.data!) {
                        if (element.nameEN == product || element.nameAR == product) {
                          postedProduct = element;
                        }
                      }
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              });
        case 2:
          return FutureBuilder<List<Product>>(
              future: FB().getMeatChicken(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'meats'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product;
                      for (var element in snapshot.data!) {
                        if (element.nameEN == product || element.nameAR == product) {
                          postedProduct = element;
                        }
                      }
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              });
        case 3:
          return FutureBuilder<List<Product>>(
              future: FB().getSeafood(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'seafood'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product;
                      for (var element in snapshot.data!) {
                        if (element.nameEN == product || element.nameAR == product) {
                          postedProduct = element;
                        }
                      }
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              });
        case 4:
          return FutureBuilder<List<Product>>(
              future: FB().getMilk(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'milk'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product;
                      for (var element in snapshot.data!) {
                        if (element.nameEN == product || element.nameAR == product) {
                          postedProduct = element;
                        }
                      }
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              });
        default:
          return const SizedBox();
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
          height: size.height * .7,
          decoration: containerRadius(radius: 15).copyWith(color: Colors.white.withOpacity(.55)),
        ),
        Positioned(
          top: 50,
          child: Container(
            width: size.width * .9,
            decoration: containerRadius(radius: 50, color: Colors.white),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: <String?>[
                    lang(context, 'fruits'),
                    lang(context, 'vegetables'),
                    lang(context, 'meats'),
                    lang(context, 'seafood'),
                    lang(context, 'milk'),
                  ].map((String? productType) {
                    return DropdownMenuItem<String>(
                      value: productType,
                      child: Center(
                        child: Text(
                          productType!,
                          style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (selected) {
                    setState(() {
                      selectedProduct = null;
                      productType = selected;
                      if (selected == lang(context, 'fruits')) {
                        index = 0;
                      }
                      if (selected == lang(context, 'vegetables')) {
                        index = 1;
                      }
                      if (selected == lang(context, 'meats')) {
                        index = 2;
                      }
                      if (selected == lang(context, 'seafood')) {
                        index = 3;
                      }
                      if (selected == lang(context, 'milk')) {
                        index = 4;
                      }
                    });
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.green,
                    ),
                  ),
                  hint: Center(
                      child: productType == null
                          ? Text(
                              lang(context, 'productType')!,
                              style: TextStyle(color: Colors.green[400]),
                              textAlign: TextAlign.right,
                            )
                          : Text(
                              productType!,
                              style: TextStyle(color: Colors.green[800]),
                              textAlign: TextAlign.right,
                            )),
                  isExpanded: true,
                  autofocus: false,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 110,
          child: buildExtra(context),
        ),
        selectedProduct != null
            ? Positioned(
                top: 170,
                width: size.width * .9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * .43,
                      decoration: containerRadius(radius: 50, color: Colors.white),
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: <String?>[
                              lang(context, 'EGP'),
                              lang(context, 'SR'),
                              lang(context, 'AED'),
                              lang(context, 'dollar'),
                            ].map((String? currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Center(
                                  child: Text(
                                    currency!,
                                    style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                currency = selected;
                                if (selected == lang(context, 'EGP')) _currency = 'EGP';
                                if (selected == lang(context, 'SR')) _currency = 'SR';
                                if (selected == lang(context, 'AED')) _currency = 'AED';
                                if (selected == lang(context, 'dollar')) _currency = 'dollar';
                              });
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.green,
                              ),
                            ),
                            hint: Center(
                                child: currency == null
                                    ? Text(
                                        lang(context, 'currency')!,
                                        style: TextStyle(color: Colors.green[400]),
                                        textAlign: TextAlign.right,
                                      )
                                    : Text(
                                        currency!,
                                        style: TextStyle(color: Colors.green[800]),
                                        textAlign: TextAlign.right,
                                      )),
                            isExpanded: true,
                            autofocus: false,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * .43,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: containerRadius(color: Colors.white, radius: 50),
                      child: TextField(
                        onChanged: (val) {
                          price = val;
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green[700]),
                        cursorColor: Colors.red,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: lang(context, 'price'),
                          hintStyle: TextStyle(color: Colors.green[400]),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        currency != null
            ? Positioned(
                top: 230,
                child: Container(
                  width: size.width * .9,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: containerRadius(color: Colors.white, radius: 50),
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green[700]),
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: lang(context, 'shopAddress'),
                      hintStyle: TextStyle(color: Colors.green[400]),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        address != null
            ? Positioned(
                bottom: 20,
                child: posting
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (productType != null && price != null && postedProduct != null && address != null) {
                            setState(() {
                              posting = true;
                            });
                            await FB().addProductPost(
                              type: productType,
                              currency: _currency,
                              price: price,
                              vendorUID: user.uid,
                              nameEN: postedProduct!.nameEN,
                              nameAR: postedProduct!.nameAR,
                              url: postedProduct!.url,
                              postUID: '${user.uid}${postedProduct!.nameEN}',
                              productAddress: address,
                            );
                            Navigator.pop(context);
                            posting = false;
                          } else {
                            setState(() {
                              posting = false;
                            });
                          }
                        },
                        child: Image.asset(
                          'assets/chick.png',
                          scale: 2,
                        )),
              )
            : const SizedBox(),
      ],
    );
  }
}
