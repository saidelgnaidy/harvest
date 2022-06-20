import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  addProductSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const AddProduct(),
        );
      },
    );
  }

  editProductSheet({String? postUID}) {
    String? price;
    bool posting = false;
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * .4,
          decoration: containerRadius(radius: 15).copyWith(color: Colors.grey[400]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: containerRadius(color: Colors.white, radius: 50),
                  child: TextField(
                    onChanged: (val) {
                      price = val;
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    cursorColor: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: lang(context, 'price'),
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(.7)),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              !posting
                  ? ElevatedButton(
                      onPressed: () async {
                        if (price != null) {
                          setState(() {
                            posting = true;
                          });
                          FB().postPrice(postUID, price);
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
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  String? selectedProduct, productType, currency;
  int? index;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final User user = Provider.of<User>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<List?>(
            stream: FB(uid: user.uid).getPostsUID,
            builder: (context, postsUID) {
              if (postsUID.hasData) {
                if (postsUID.data!.isNotEmpty) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.builder(
                        itemCount: postsUID.data!.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<Product>(
                              stream: FB(uid: postsUID.data![index]).getPostedProducts,
                              builder: (context, post) {
                                if (post.hasData) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: size.width,
                                        height: 80,
                                        margin: const EdgeInsets.fromLTRB(8, 4, 30, 4),
                                        decoration: containerRadius(radius: 10),
                                      ),
                                      Positioned(
                                        right: 5,
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Image.network(
                                            post.data!.url!,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 100,
                                        top: 15,
                                        child: Text(
                                          langCode(context) == 'ar' ? post.data!.nameAR! : post.data!.nameEN ?? '',
                                          style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                          textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        right: 100,
                                        top: 50,
                                        child: Text(
                                          '${post.data!.price}',
                                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                          textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        right: 140,
                                        top: 50,
                                        child: Text(
                                          '${lang(context, '${post.data!.currency}')}',
                                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                          textAlign: langCode(context) == 'ar' ? TextAlign.right : TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        left: 5,
                                        top: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          onPressed: () {
                                            FB(uid: user.uid).deletePost(post.data!.postUID);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: 5,
                                        bottom: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          onPressed: () {
                                            editProductSheet(postUID: post.data!.postUID);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              });
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
            }),
        Positioned(
          bottom: 8,
          child: SizedBox(
            width: 60,
            child: RawMaterialButton(
              elevation: 5,
              shape: const StadiumBorder(),
              onPressed: () {
                setState(() {
                  addProductSheet();
                });
              },
              fillColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(
                Icons.add_box,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
