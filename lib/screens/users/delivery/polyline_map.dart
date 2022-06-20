// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_map_polyline/google_map_polyline.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:harvest/util/applocale.dart';
// import 'package:harvest/util/util.dart';
// import 'package:location/location.dart';
//
//
// LocationData _myLocation;
//
//
// class PolyLineMap extends StatefulWidget {
//
//   final LatLng origin , destination ;
//   final Product order ;
//   PolyLineMap({@required this.origin,@required this.destination, this.order});
//
//   @override
//   _PolyLineMapState createState() => _PolyLineMapState();
// }
//
// class _PolyLineMapState extends State<PolyLineMap>  {
//
//   GoogleMapController _mapController;
//   MapType mapType = MapType.normal ;
//   Set<Polyline> polylineSet = {};
//   List<Marker> markers = [] ;
//   List<LatLng> routeCords = [] ;
//   GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: 'AIzaSyBUuVVvIkfdlLYQMJtevk5fS85pKdu6m28') ;
//
//
//   @override
//   void initState() {
//
//     super.initState();
//     _myCurrentLocation();
//     drawLine();
//     markers  = [
//       Marker(
//         markerId: MarkerId(widget.origin.toString()),
//         position: widget.origin,
//         icon: BitmapDescriptor.defaultMarkerWithHue(20.0),
//       ),
//       Marker(
//         markerId: MarkerId(widget.destination.toString()),
//         position: widget.destination,
//         icon: BitmapDescriptor.defaultMarkerWithHue(300.0),
//       ),
//     ];
//
//   }
//
//
//
//   drawLine() async {
//     routeCords = await googleMapPolyline.getCoordinatesWithLocation(
//       origin: LatLng(widget.origin.latitude,widget.origin.longitude),
//       destination: LatLng(_myLocation.latitude+.001,_myLocation.longitude+.02),
//       mode: RouteMode.driving,
//     );
//   }
//
//
//   _myCurrentLocation() async {
//     if(_myLocation == null ){
//       final myLocation = await Location().getLocation();
//       setState(() {
//         _myLocation = myLocation ;
//       });
//     }
//   }
//
//   animateToLocation(LatLng latLng ) {
//     _mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: latLng,
//           zoom: 14,
//           tilt: 90.0,
//         ),
//       ),
//     );
//   }
//
//   onMapCreated(controller) {
//     setState(() {
//       _mapController = controller;
//       polylineSet.add(Polyline(
//         polylineId: PolylineId(widget.origin.toString()),
//         visible: true,
//         points: routeCords,
//         color: Colors.blue,
//         width: 6,
//       ));
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffE4E6EB),
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           _myLocation != null ?
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(_myLocation.latitude, _myLocation.longitude),
//               zoom: 8,
//               tilt: 10.0,
//             ),
//             polylines: polylineSet,
//             markers: Set.of(markers),
//             mapType: mapType,
//             onMapCreated: onMapCreated,
//             tiltGesturesEnabled: true,
//             myLocationEnabled: true,
//             compassEnabled: false,
//             zoomControlsEnabled: false,
//             mapToolbarEnabled: false,
//             myLocationButtonEnabled: false,
//             buildingsEnabled: false,
//             indoorViewEnabled: false,
//             trafficEnabled: false,
//           ):
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Text(lang(context, 'gettingLocation')),
//                   ),
//                   CircularProgressIndicator(),
//                 ],
//               ),
//             ),
//           ),
//
//           Positioned(
//             bottom: 10,
//             right: 10,
//             width: 180,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 RawMaterialButton(
//                   fillColor: Colors.greenAccent,
//                   shape: StadiumBorder(),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text('Client Location',textAlign: TextAlign.center,),
//                         SizedBox(width: 10,),
//                         Image.asset('assets/my_marker.png'),
//                       ],
//                     ),
//                   ),
//                   onPressed: () {
//                     animateToLocation(LatLng(widget.destination.latitude, widget.destination.longitude));
//                   },
//                 ),
//                 RawMaterialButton(
//                   fillColor: Colors.greenAccent,
//                   shape: StadiumBorder(),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text('Vendor Location',textAlign: TextAlign.center,),
//                         SizedBox(width: 10,),
//                         Image.asset('assets/marker.png'),
//                       ],
//                     ),
//                   ),
//                   onPressed: () {
//                     animateToLocation(LatLng(widget.origin.latitude, widget.origin.longitude));
//                   },
//                 ),
//                 RawMaterialButton(
//                   fillColor: Colors.greenAccent,
//                   shape: StadiumBorder(),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text('My Location',textAlign: TextAlign.center,),
//                         SizedBox(width: 10,),
//                         Image.asset('assets/my_marker.png'),
//                       ],
//                     ),
//                   ),
//                   onPressed: () {
//                     animateToLocation(LatLng(_myLocation.latitude, _myLocation.longitude));
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
