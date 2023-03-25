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
import 'package:lost_found_steelhacks/lostObject.dart';
import 'package:lost_found_steelhacks/lostObject.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:lost_found_steelhacks/itemRequest.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  late GoogleMapController mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  int counter = 0;

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

  //University of Pittsburgh Coordinates
  final LatLng _center = const LatLng(40.4443533, -79.960835);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _lostCollectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something Has Gone Wrong Please Refresh");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Waiting Getting Data");
          }

          //List<LostObject> lostObjects = [];
          //query database, go through each item in database, and create list of lost objects
          for (int i = 0; i < snapshot.data!.size; i++) {
            QueryDocumentSnapshot singleDoc = snapshot.requireData.docs[i];
            //LostObject lostItem = LostObject.fromFirestore(singleDoc, null);
            print(singleDoc.data());
          }

          PanelController _panelController = PanelController();
          return Scaffold(
            appBar: AppBar(
              title: const Text("Lost and Found"),
            ),
            body:
            SlidingUpPanel(
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
              body:
              GoogleMap(
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
          
    }
  );}
}
