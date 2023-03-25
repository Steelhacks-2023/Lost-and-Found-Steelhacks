import 'dart:developer';
import 'dart:html';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart'
    as GWebMap;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/listPage.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:lost_found_steelhacks/itemRequest.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:icon_forest/icon_forest.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  late GoogleMapController mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late BitmapDescriptor foundMarkerIcon;

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  int counter = 0;

  @override
  initState() {
    setFoundMarkerIcon();
  }

  void setFoundMarkerIcon() async {
    foundMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/blue_marker.png');
  }

  void _add(double lat, double long) {
    final MarkerId markerId = MarkerId("ID" + counter.toString());

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon,
      position: LatLng(
        lat,
        long,
      ),
      //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      // onTap: () {
      //   _onMarkerTapped(markerId);
      // },
    );
    counter++;
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  final Stream<QuerySnapshot> _lostCollectionStream =
      FirebaseFirestore.instance.collection('Lost').snapshots();

  final Stream<QuerySnapshot> _foundCollectionStream =
      FirebaseFirestore.instance.collection('Found').snapshots();

  //University of Pittsburgh Coordinates
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _foundCollectionStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> foundSnapshot) {
          return StreamBuilder<QuerySnapshot>(
              stream: _lostCollectionStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> lostSnapshot) {
                if (lostSnapshot.hasError || foundSnapshot.hasError) {
                  return Text("Something Has Gone Wrong Please Refresh");
                } else if (lostSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    lostSnapshot.connectionState == ConnectionState.waiting) {
                  return Text("Waiting Getting Data");
                }

                List<LostAndFoundObject> lostObjects = [];
                List<LostAndFoundObject> foundObjects = [];
                //query database, go through each item in database, and create list of lost objects
                for (int i = 0; i < foundSnapshot.data!.size; i++) {
                  QueryDocumentSnapshot singleDoc =
                      lostSnapshot.requireData.docs[i];
                  var data = singleDoc.data() as Map;
                  LostAndFoundObject foundItem =
                      LostAndFoundObject.fromFirestore(singleDoc, null);
                  foundObjects.add(foundItem);
                  GeoPoint geo = data["Location"];
                  //_add(geo.latitude, geo.longitude);
                  final MarkerId temp = MarkerId(singleDoc.id);
                  final Marker marker = Marker(
                    markerId: temp,
                    icon: foundMarkerIcon,
                    position: LatLng(geo.latitude, geo.longitude),
                    //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
                    // onTap: () {
                    //   _onMarkerTapped(markerId);
                    // },
                  );
                  markers[temp] = marker;
                }
                for (int i = 0; i < lostSnapshot.data!.size; i++) {
                  QueryDocumentSnapshot singleDoc =
                      lostSnapshot.requireData.docs[i];
                  var data = singleDoc.data() as Map;
                  //print(data["Description"].toString() + data["Phone"].toString());
                  LostAndFoundObject lostItem =
                      LostAndFoundObject.fromFirestore(singleDoc, null);
                  lostObjects.add(lostItem);
                  GeoPoint geo = data["Location"];
                  //_add(geo.latitude, geo.longitude);
                  final MarkerId temp = MarkerId(singleDoc.id);
                  final Marker marker = Marker(
                    markerId: temp,
                    icon: markerIcon,
                    position: LatLng(geo.latitude, geo.longitude),
                    //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
                    // onTap: () {
                    //   _onMarkerTapped(markerId);
                    // },
                  );
                  markers[temp] = marker;
                }

                PanelController _panelController = PanelController();
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Lost and Found"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {  
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => listPage(entries: lostObjects))
                          );
                        },
                        child: null,
                      )
                    ]
                  ),
                  body: SlidingUpPanel(
                    // defaultPanelState: PanelState.CLOSED,
                    // minHeight: 0,
                    controller: _panelController,
                    backdropEnabled: true,
                    collapsed: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                        ),
                        child: const Center(
                            child: Text(
                          "what should go here?",
                          style: TextStyle(color: Colors.white),
                        ))),
                    panel: FormWidget(),
                    body: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16,
                      ),
                      onTap: (coords) {
                        _add(coords.latitude, coords.longitude);
                        _panelController.open();

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SwitchApp(coord: coords)));
                      },
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                );

                //       body: Stack(alignment: Alignment.center, children: [

                //     SlidingUpPanel(
                //       // defaultPanelState: PanelState.CLOSED,
                //       // minHeight: 0,
                //       controller: PanelController(),
                //       backdropEnabled: true,
                //       collapsed: Container(
                //           decoration: const BoxDecoration(
                //             color: Colors.blueGrey,
                //           ),
                //           child: const Center(
                //               child: Text(
                //             "what should go here?",
                //             style: TextStyle(color: Colors.white),
                //           ))),
                //       panel: FormWidget(),
                //     ),

                //     GoogleMap(
                //       initialCameraPosition: CameraPosition(
                //         target: _center,
                //         zoom: 16,
                //       ),
                //       onTap: (coords) {
                //         _add(coords.latitude, coords.longitude);

                //         // Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //         builder: (context) => SwitchApp(coord: coords)));
                //       },
                //       markers: Set<Marker>.of(markers.values),
                //     ),

                //     SlidingUpPanel(
                //       // defaultPanelState: PanelState.CLOSED,
                //       // minHeight: 0,
                //       controller: PanelController(),
                //       backdropEnabled: true,
                //       collapsed: Container(
                //           decoration: const BoxDecoration(
                //             color: Colors.blueGrey,
                //           ),
                //           child: const Center(
                //               child: Text(
                //             "what should go here?",
                //             style: TextStyle(color: Colors.white),
                //           ))),
                //       panel: FormWidget(),
                //     ),

                //     //THESE ARE THE INDIVIDUAL POST AND POST CREATION BUTTONS
                //     // Column(
                //     //   mainAxisAlignment: MainAxisAlignment.end,
                //     //   children: [
                //     //     FloatingActionButton(
                //     //       onPressed: (() {
                //     //         Navigator.push(
                //     //             context,
                //     //             MaterialPageRoute(
                //     //                 builder: (context) => const PostPage()));
                //     //       }),
                //     //     ),
                //     //   ],
                //     // ),
                //   ]));
                // });
              });
        });
  }
}
