import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/util/util.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

LocationData? _myLocation;

class ResultsInMaps extends StatefulWidget {
  final String productName;

  const ResultsInMaps({Key? key, required this.productName}) : super(key: key);

  @override
  _ResultsInMapsState createState() => _ResultsInMapsState();
}

class _ResultsInMapsState extends State<ResultsInMaps> {
  GoogleMapController? _mapController;
  List<Marker> allMarkers = [];
  BehaviorSubject<double> radius = BehaviorSubject.seeded(20);
  late StreamSubscription _subscription;
  MapType mapType = MapType.hybrid;
  List<Product> productsFromDB = [];
  List<String?> postsUID = [];

  @override
  void initState() {
    _myCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    supCancel();
    super.dispose();
  }

  supCancel() async {
    await _subscription.cancel();
  }

  _myCurrentLocation() async {
    LocationData pos = await Location.instance.getLocation();
    setState(() {
      _myLocation = pos;
    });
  }

  animateToMyLocation() {
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myLocation!.latitude!, _myLocation!.longitude!), zoom: 14, tilt: 90.0),
      ),
    );
  }

  onMapCreated(controller) {
    setState(() {
      _mapController = controller;
      _startQuery();
    });
  }

  _startQuery() {
    double? lat = _myLocation!.latitude, lon = _myLocation!.longitude;
    var postsRef = FirebaseFirestore.instance.collection('ProductPosts').where('nameEN', isEqualTo: widget.productName);
    GeoFirePoint center = GeoFirePoint(lat!, lon!);
    final GeoFireCollectionRef ref = GeoFireCollectionRef(postsRef);
    _subscription = radius.switchMap((rad) {
      return ref.within(center: center, radius: rad, field: 'postLocation', strictMode: true);
    }).listen(updateMarkers);
  }

  updateMarkers(List<DocumentSnapshot> docList) async {
    debugPrint('doc.data: ${docList.length}*************');
    for (var doc in docList) {
      GeoPoint geoPoint = doc.get('postLocation')['geopoint'];
      Marker marker = Marker(
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        markerId: MarkerId(doc.get('postUID')),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: '${doc.get('price')}  ${doc.get('currency')}'),
        onTap: () {
          showBuySheet(
            context,
            Product(
              nameAR: doc.get('nameAR'),
              nameEN: doc.get('nameEN'),
              type: doc.get('type'),
              postUID: doc.get('postUID'),
              currency: doc.get('currency'),
              vendorUID: doc.get('VendorUID'),
              price: doc.get('price'),
              url: doc.get('url'),
              postLocation: doc.get('postLocation'),
              productAddress: doc.get('productAddress'),
              postLatLang: LatLng(geoPoint.latitude, geoPoint.longitude),
            ),
          );
        },
      );
      Product post = Product(
        nameAR: doc.get('nameAR'),
        nameEN: doc.get('nameEN'),
        type: doc.get('type'),
        postUID: doc.get('postUID'),
        currency: doc.get('currency'),
        vendorUID: doc.get('VendorUID'),
        price: doc.get('price'),
        url: doc.get('url'),
        postLocation: doc.get('postLocation'),
        productAddress: doc.get('productAddress'),
        postLatLang: LatLng(geoPoint.latitude, geoPoint.longitude),
      );
      setState(() {
        allMarkers.add(marker);
        if (!postsUID.contains(post.postUID)) {
          postsUID.add(post.postUID);
          productsFromDB.add(post);
        }
      });
    }
  }

  _updateQuery(value) {
    final zoomMap = {20: 12, 30: 11.2, 40: 10.4, 50: 9.6, 60: 8.8};
    final zoom = zoomMap[value]!.toDouble();
    _mapController!.moveCamera(CameraUpdate.zoomTo(zoom));
    setState(() => radius.add(value));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffE4E6EB),
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _myLocation != null
              ? GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(30.5128009, 31.3440008),
                    zoom: 10,
                    tilt: 45.0,
                  ),
                  markers: Set.from(allMarkers),
                  onMapCreated: onMapCreated,
                  tiltGesturesEnabled: true,
                  mapType: mapType,
                  myLocationEnabled: true,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                  buildingsEnabled: false,
                  indoorViewEnabled: false,
                  trafficEnabled: false,
                )
              : Center(
                  child: Image.asset('assets/loading_trend.gif'),
                ),
          Positioned(
            bottom: 65,
            left: 5,
            height: size.height * .25,
            width: size.width,
            child: PostsView(
              products: productsFromDB,
              mapController: _mapController,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Slider(
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(.4),
              max: 60,
              min: 20,
              divisions: 4,
              label: "${radius.value} km",
              value: radius.value,
              onChanged: _updateQuery,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 65,
            width: 50,
            height: 50,
            child: RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.secondary,
              shape: const StadiumBorder(),
              child: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (mapType == MapType.normal) {
                    mapType = MapType.satellite;
                  } else if (mapType == MapType.satellite) {
                    mapType = MapType.hybrid;
                  } else if (mapType == MapType.hybrid) {
                    mapType = MapType.terrain;
                  } else {
                    mapType = MapType.normal;
                  }
                });
              },
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            width: 50,
            height: 50,
            child: RawMaterialButton(
              fillColor: Theme.of(context).colorScheme.secondary,
              shape: const StadiumBorder(),
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              onPressed: () {
                animateToMyLocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
