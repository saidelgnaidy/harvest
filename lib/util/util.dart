import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/screens/users/commen/maps.dart';
import 'dart:ui';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:provider/provider.dart';

bool loading = false;

enum SignInUp {
  logIn,
  signUp,
}

enum AccType {
  client,
  delivery,
  vendor,
}

class Product {
  final String? nameAR, nameEN, url, currency, orderUID, price, type, vendorUID, postUID, quantity, clientAddress, productAddress, clientUID;
  final int? orderState;
  final Map? postLocation, clientLocation;
  final LatLng? postLatLang;
  Product(
      {this.postLatLang,
      this.orderUID,
      this.nameAR,
      this.nameEN,
      this.url,
      this.currency,
      this.price,
      this.type,
      this.vendorUID,
      this.postUID,
      this.quantity,
      this.clientAddress,
      this.productAddress,
      this.clientUID,
      this.orderState,
      this.postLocation,
      this.clientLocation});
}

class Users {
  final String? name, uid, phone, cCode, accType;
  Users({this.name, this.uid, this.phone, this.cCode, this.accType});
}

class MyTextField extends StatelessWidget {
  final Size size;
  final String? label;
  final TextInputType? textInputType;
  final bool? obscure;
  final Function? onChanged;
  final Widget? preWidget;
  final int? length;

  const MyTextField({Key? key, required this.size, this.label, this.textInputType, this.obscure, this.onChanged, this.preWidget, this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * .8,
      height: 50,
      child: TextField(
        onChanged: onChanged as void Function(String)?,
        cursorColor: Theme.of(context).backgroundColor,
        style: TextStyle(color: Theme.of(context).backgroundColor),
        textAlign: TextAlign.center,
        keyboardType: textInputType,
        obscureText: obscure ?? false,
        maxLength: length,
        decoration: InputDecoration(
            labelText: label,
            counter: const SizedBox.shrink(),
            labelStyle: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(width: 1, color: Theme.of(context).backgroundColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(width: 1, color: Theme.of(context).backgroundColor),
            ),
            border: InputBorder.none),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Function? onPressed;
  final String? title;
  final bool? hasBorders;

  const Button({Key? key, this.onPressed, this.title, this.hasBorders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed as void Function()?,
      child: Text(
        title!,
        textAlign: TextAlign.center,
      ),
      shape: const StadiumBorder(),
      fillColor: hasBorders! ? Theme.of(context).backgroundColor : Colors.white,
      splashColor: Colors.black45,
    );
  }
}

BoxDecoration containerBorders(BuildContext context) {
  return BoxDecoration(
    border: Border.all(width: 1.0, color: Theme.of(context).backgroundColor),
    borderRadius: const BorderRadius.all(
      Radius.circular(50),
    ),
  );
}

BoxDecoration containerRadius({required double radius, Color? color}) {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), offset: const Offset(3, 3), blurRadius: 3, spreadRadius: 2)],
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}

blurContainer({required double w, required double h, required double radius, Widget? child}) {
  return ClipPath(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    ),
  );
}

class MyCountryCode extends StatelessWidget {
  final Function? onChanged, onInit;

  const MyCountryCode({Key? key, this.onChanged, this.onInit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 50,
      decoration: containerBorders(context),
      child: CountryCodePicker(
        onChanged: onChanged as void Function(CountryCode)?,
        barrierColor: Colors.black26,
        showFlag: false,
        hideSearch: true,
        textStyle: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 12),
        initialSelection: 'EG',
        favorite: const ['SA', 'EG', 'AE', 'SY', 'OM', 'MC', 'KW', 'JO', 'IR', 'IQ', 'PS', 'QA', 'BH', 'YE', 'TN', 'DZ', 'LB', 'LY'],
        showFlagDialog: true,
        comparator: (a, b) => b.name!.compareTo(a.name!),
        onInit: onInit as void Function(CountryCode?)?,
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  final String? title, selectedProduct;
  final List<Product>? productList;
  final Function? onChanged;

  const ProductsList({Key? key, this.title, this.selectedProduct, this.productList, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .9,
          decoration: containerRadius(radius: 50, color: Colors.white),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: productList!.map((Product product) {
                  return DropdownMenuItem<String>(
                    value: langCode(context) == 'ar' ? product.nameAR : product.nameEN,
                    child: Center(
                      child: Text(
                        langCode(context) == 'ar' ? product.nameAR! : product.nameEN!,
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged as void Function(String?)?,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.secondary),
                ),
                hint: Center(
                    child: selectedProduct == null
                        ? Text(
                            title!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(.5)),
                            textAlign: TextAlign.right,
                          )
                        : Text(
                            selectedProduct!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.right,
                          )),
                isExpanded: true,
                autofocus: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyGridView extends StatelessWidget {
  final List<Product>? products;

  const MyGridView({Key? key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5),
        itemCount: products!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsInMaps(productName: products![index].nameEN!.toString())));
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: size.height * .2,
                    width: size.width * .45,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: size.height * .12,
                      width: size.width * .45,
                      decoration: containerRadius(radius: 10),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: size.width * .22,
                      width: size.width * .22,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(products![index].url!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    child: Text(
                      langCode(context) == 'ar' ? products![index].nameAR! : products![index].nameEN!,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class PostsView extends StatelessWidget {

  final List<Product> products;
  final GoogleMapController? mapController;

  const PostsView({Key? key, required this.products, this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (products.isNotEmpty) {
      return ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  showBuySheet(context, products[index]);
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: size.height * .25,
                      width: size.width * .45,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: size.height * .19,
                        width: size.width * .45,
                        decoration: containerRadius(radius: 20).copyWith(
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), offset: const Offset(0, 3), blurRadius: 3, spreadRadius: 2)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: size.width * .2,
                        width: size.width * .45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(products[index].url!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.width * .2 + 10,
                      right: 10,
                      child: Text(
                        langCode(context) == 'ar' ? products[index].nameAR! : products[index].nameEN!,
                        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Positioned(
                      top: size.width * .2 + 35,
                      right: 10,
                      child: Text(
                        '${products[index].currency}    ${products[index].price}',
                        style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.secondary),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Positioned(
                      bottom: -6,
                      left: 0,
                      child: SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          child: Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          shape: const StadiumBorder(),
                          onPressed: () {
                            mapController!.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: products[index].postLatLang!,
                                  zoom: 16,
                                  tilt: 90,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -6,
                      right: 0,
                      child: SizedBox(
                        width: 50,
                        child: RawMaterialButton(
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          shape: const StadiumBorder(),
                          onPressed: () {
                            showBuySheet(context, products[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                lang(context, 'expandSearch')!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: containerRadius(
              radius: 20,
            ).copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Image.asset('assets/loading_card.gif');
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

showBuySheet(BuildContext context, Product post) {
  double quantity = 1.0;
  String deliverAddress = '';
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final User user = Provider.of<User>(context);
      return FutureBuilder<Object?>(
          future: FB(uid: user.uid).myDeliverAddress(),
          builder: (context, snap) {
            if (snap.hasData) {
              deliverAddress = snap.data.toString();
              return StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          right: 5,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(post.url!),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 120,
                          child: Text(
                            AppLocale.of(context)!.locale!.languageCode == 'ar' ? post.nameAR! : post.nameEN!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 120,
                          child: Text(
                            post.price!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 150,
                          child: Text(
                            lang(context, post.currency)!,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Positioned(
                          top: 60,
                          right: 15,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  setState.call(() {
                                    quantity = quantity + .5;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  if (quantity > 0.5) {
                                    setState.call(() {
                                      quantity = quantity - .5;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 100,
                          right: 80,
                          child: Text(
                            '$quantity  kgm',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Positioned(
                            bottom: 75,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: containerRadius(radius: 50).copyWith(color: Colors.white),
                              child: TextFormField(
                                initialValue: deliverAddress,
                                onChanged: (val) {
                                  deliverAddress = val;
                                },
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                cursorColor: Theme.of(context).colorScheme.secondary,
                                decoration: InputDecoration(
                                  hintText: lang(context, 'deliverAddress'),
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(.7)),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                        Positioned(
                          bottom: 10,
                          child: SizedBox(
                            width: 200,
                            height: 45,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Order',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '  ${quantity * double.parse(post.price!)} ${post.currency}',
                                    style: const TextStyle(color: Colors.yellow),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (deliverAddress == '' && snap.data.toString() == '') {
                                  Fluttertoast.showToast(
                                    msg: lang(context, 'addDeliverAddress').toString(),
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else {
                                  FB(uid: user.uid).placeAnOrder(
                                    nameEN: post.nameEN,
                                    nameAR: post.nameAR,
                                    url: post.url,
                                    price: post.price,
                                    vendorUID: post.vendorUID,
                                    currency: post.currency,
                                    postUID: post.postUID,
                                    type: post.type,
                                    quantity: quantity.toString(),
                                    postLocation: post.postLocation,
                                    clientAddress: deliverAddress,
                                    postAddress: post.productAddress,
                                  );
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                    msg: lang(context, 'orderPlaced').toString(),
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    },
  );
}
