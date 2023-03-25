import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart'
    as GWebMap;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  late GoogleMapController mapController;

  final Stream<QuerySnapshot> _lostCollectionStream =
      FirebaseFirestore.instance.collection('Lost').snapshots();

    // ignore: prefer_collection_literals

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
          return Scaffold(
              body: Stack(alignment: Alignment.center, children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16,
              ),
            ),
            FloatingActionButton(
              onPressed: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PostPage()));
              }),
            ),
          SlidingUpPanel(
            backdropEnabled: true,
            collapsed: Container(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: const Center(
                child: Text(
                  "What can we add here?",
                  style: TextStyle(color:Colors.white),
                )
              )
            ),
            panel: Center(child: Text("What goes here"),),
            
          )
          ]));
        });
  }
}
