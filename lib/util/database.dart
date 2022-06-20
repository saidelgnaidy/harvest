import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:harvest/util/util.dart';
import 'package:location/location.dart';

class FB {
  String? errorMsg;
  final String? uid;

  FB({this.uid});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference clients = FirebaseFirestore.instance.collection('Clients');
  final CollectionReference phones = FirebaseFirestore.instance.collection('Phones');
  final CollectionReference fruits = FirebaseFirestore.instance.collection('Fruits');
  final CollectionReference vegetables = FirebaseFirestore.instance.collection('Vegetables');
  final CollectionReference seafood = FirebaseFirestore.instance.collection('fish');
  final CollectionReference meatAndChicken = FirebaseFirestore.instance.collection('Meat and chicken');
  final CollectionReference milk = FirebaseFirestore.instance.collection('Milk');
  final CollectionReference productPosts = FirebaseFirestore.instance.collection('ProductPosts');
  final CollectionReference orders = FirebaseFirestore.instance.collection('Orders');
  List<Product> receivedOrders = [];
  List<Product> fruitList = [];
  List<Product> vegetablesList = [];
  List<Product> seafoodList = [];
  List<Product> milkList = [];
  List<Product> meatChickenList = [];
  List<Product> clientOrders = [];

  Future createNewClient({String? name, phone, accType, cCode, uid}) async {
    List posts = [];
    return await clients
        .doc(uid)
        .set({'Name': name, 'Phone': phone, 'CCode': cCode, 'AccType': accType.toString(), 'UID': uid, 'posts': posts, 'deliverAddress': '', 'pic': ''});
  }

  Future addProductPost({String? nameAR, nameEN, url, vendorUID, price, currency, type, postUID, productAddress}) async {
    LocationData pos = await Location.instance.getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude!, pos.longitude!);

    await clients.doc(vendorUID).update({
      'posts': FieldValue.arrayUnion(['$vendorUID$nameEN'])
    });

    return await productPosts.doc('$vendorUID$nameEN').set({
      'nameAR': nameAR,
      'nameEN': nameEN,
      'url': url,
      'VendorUID': vendorUID,
      'price': price,
      'currency': currency,
      'type': type,
      'postUID': postUID,
      'postLocation': point.data,
      'productAddress': productAddress,
    });
  }

  Future placeAnOrder(
      {String? nameAR, nameEN, clientAddress, String? postAddress, url, vendorUID, price, currency, type, postUID, quantity, Map? postLocation}) async {
    LocationData pos = await Location.instance.getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude!, pos.longitude!);

    await clients.doc(vendorUID).update({
      'orders': FieldValue.arrayUnion(['$uid$vendorUID$nameEN'])
    });

    await clients.doc(uid).update({
      'deliverAddress': clientAddress,
    });

    await orders.doc('$uid$vendorUID$nameEN').set({
      'nameAR': nameAR,
      'nameEN': nameEN,
      'url': url,
      'VendorUID': vendorUID,
      'price': price,
      'currency': currency,
      'type': type,
      'postUID': postUID,
      'clientLocation': point.data,
      'clientAddress': clientAddress,
      'productAddress': postAddress,
      'quantity': quantity,
      'postLocation': postLocation,
      'orderState': 25,
      'clientUID': uid,
      'orderUID': '$uid$vendorUID$nameEN',
    });
  }

  Future updateMyLocation() async {
    LocationData pos = await Location.instance.getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude!, pos.longitude!);
    return await clients.doc(uid).update({
      'Location': point.data,
    });
  }

  Future signOut() async {
    await auth.signOut();
  }

  Stream<User?> get userState {
    return auth.authStateChanges();
  }

  updateAccType(AccType? accountType) async {
    await clients.doc(uid).update({
      'AccType': accountType.toString(),
    });
  }

//To check If a phone is registered or not ****************************************
  Future addPhone({String? phone, cCode}) async {
    return await phones.doc(phone).set({
      'Phones': phone,
      'CCode': cCode,
    });
  }

  Future<bool> alreadyRegistered({String? phone}) async {
    final docs = await phones.where('Phones', isEqualTo: phone).get();
    if (docs.size == 0) {
      return false;
    } else {
      return true;
    }
  }

  //get my delivery address **************************************************
  Future<String?> myDeliverAddress() async {
    String? deliverAddress;
    await clients.doc(uid).get().then((doc) {
      deliverAddress = doc.get('deliverAddress');
    });
    return deliverAddress;
  }

// get all Products as future and as stream ***************************************
  Future<List<Product>> getFruits() async {
    List<Product> fruitsList = [];
    final products = await fruits.get();
    for (var doc in products.docs) {
      fruitsList.add(Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        url: doc.get('url'),
      ));
    }
    return fruitsList;
  }

  Stream<List<Product>> get fruitsStream {
    return fruits.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        fruitList.add(Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
        ));
      }
      return fruitList;
    });
  }

  Future<List<Product>> getVegetables() async {
    List<Product> vegetablesList = [];
    final products = await vegetables.get();
    for (var doc in products.docs) {
      vegetablesList.add(Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        url: doc.get('url'),
      ));
    }
    return vegetablesList;
  }

  Stream<List<Product>> get vegetablesStream {
    return vegetables.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        vegetablesList.add(Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
        ));
      }
      return vegetablesList;
    });
  }

  Future<List<Product>> getSeafood() async {
    List<Product> seafoodList = [];
    final products = await seafood.get();
    for (var doc in products.docs) {
      seafoodList.add(Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        url: doc.get('url'),
      ));
    }
    return seafoodList;
  }

  Stream<List<Product>> get seafoodStream {
    return seafood.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        seafoodList.add(Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
        ));
      }
      return seafoodList;
    });
  }

  Future<List<Product>> getMilk() async {
    List<Product> milkList = [];
    final products = await milk.get();
    for (var doc in products.docs) {
      milkList.add(Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        url: doc.get('url'),
      ));
    }
    return milkList;
  }

  Stream<List<Product>> get milkStream {
    return milk.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        milkList.add(Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
        ));
      }
      return milkList;
    });
  }

  Future<List<Product>> getMeatChicken() async {
    List<Product> meatChickenList = [];
    final products = await meatAndChicken.get();
    for (var doc in products.docs) {
      meatChickenList.add(Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        url: doc.get('url'),
      ));
    }
    return meatChickenList;
  }

  Stream<List<Product>> get meatChickenStream {
    return meatAndChicken.snapshots().map((snapshot) {
      for (var doc in snapshot.docs) {
        meatChickenList.add(Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
        ));
      }
      return meatChickenList;
    });
  }
//********************************************************************************

//to get the posts uid from the current user doc *********************************
  Stream<List?> get getPostsUID {
    return clients.doc(uid).snapshots().map((snapshot) {
      return snapshot.get('posts');
    });
  }

//to get posts  from productPosts collection     *********************************
  Stream<Product> get getPostedProducts {
    return productPosts.doc(uid).snapshots().map((snapshot) {
      return Product(
        nameAR: snapshot.get('nameAR'),
        nameEN: snapshot.get('nameEN'),
        url: snapshot.get('url'),
        price: snapshot.get('price'),
        vendorUID: snapshot.get('VendorUID'),
        currency: snapshot.get('currency'),
        type: snapshot.get('type'),
        postUID: snapshot.get('postUID'),
        postLocation: snapshot.get('postLocation'),
        productAddress: snapshot.get('productAddress'),
      );
    });
  }

  Stream<List<Product>> get getReceivedOrders {
    return orders.where('VendorUID', isEqualTo: uid).snapshots().map((snapshot) {
      receivedOrders = [];
      for (var doc in snapshot.docs) {
        receivedOrders.add(
          Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url: doc.get('url'),
          price: doc.get('price'),
          vendorUID: doc.get('VendorUID'),
          currency: doc.get('currency'),
          type: doc.get('type'),
          postUID: doc.get('postUID'),
          postLocation: doc.get('postLocation'),
          productAddress: doc.get('productAddress'),
        )
        );
      }
      return receivedOrders;
    });
  }

  Stream<List<Product>> get getClientOrders {
    return orders.where('clientUID', isEqualTo: uid).snapshots().map((snap) {
      clientOrders = [];
      for (var doc in snap.docs) {
        clientOrders.add(Product(
          vendorUID: doc.get('VendorUID'),
          clientLocation: doc.get('clientLocation'),
          currency: doc.get('currency'),
          postLocation: doc.get('postLocation'),
          quantity: doc.get('quantity'),
          url: doc.get('url'),
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          productAddress: doc.get('productAddress'),
          clientAddress: doc.get('clientAddress'),
          price: doc.get('price'),
          type: doc.get('type'),
          postUID: doc.get('postUID'),
          clientUID: doc.get('clientUID'),
          orderState: doc.get('orderState'),
          orderUID: doc.get('orderUID'),
        ));
      }
      return clientOrders;
    });
  }

  Future deletePost(postUID) async {
    await productPosts.doc(postUID).delete();
    return await clients.doc(uid).update({
      'posts': FieldValue.arrayRemove([postUID])
    });
  }

  Future postPrice(String? postUID, String? price) async {
    return await productPosts.doc(postUID).update({'price': price});
  }

  Future cancelOrder(orderUID, int orderState) async {
    return await orders.doc(orderUID).update({
      'orderState': orderState,
    });
  }

  Future deleteOrder(orderUID, vendorUID) async {
    await clients.doc(vendorUID).update({
      'orders': FieldValue.arrayRemove([orderUID])
    });
    await orders.doc(orderUID).delete();
  }

  Stream<Users> get getAccType {
    return clients.doc(uid).snapshots().map((doc) {
      return Users(accType: doc.get('AccType'));
    });
  }

  Stream<Users> get userByUId {
    return clients.doc(uid).snapshots().map((doc) {
      return Users(
        uid: doc.get('UID'),
        accType: doc.get('AccType'),
        cCode: doc.get('CCode'),
        name: doc.get('Name'),
        phone: doc.get('Phone'),
      );
    });
  }
}
