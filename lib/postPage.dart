import 'package:flutter/material.dart';
import 'package:icon_forest/icon_forest.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/mapPage.dart';
import 'package:lost_found_steelhacks/listPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// title: 'Flutter Project',
// theme: ThemeData(
//   primarySwatch: Colors.blue,
//   textTheme: Theme.of(context).textTheme.apply(
//   fontFamily: 'Monserrat',
//   bodyColor: Color.fromARGB(255, 2, 12, 20),
//   displayColor: Colors.black),

class PostPage extends StatefulWidget {
  final LostAndFoundObject item;
  final List<LostAndFoundObject> lostObjects;
  final List<LostAndFoundObject> foundObjects;
  const PostPage({super.key, required this.item, required this.lostObjects, required this.foundObjects});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    var dim = MediaQuery.of(context).size;
    var dim_x = dim.width;
    var dim_y = dim.height;
    var edge_padding = 0.02 * dim_y;
    var widget_padding = 0.01 * dim_y;
    var border_radius = Radius.circular(10);
    var header_row_spacing = 0.2 * dim_x;

    return Scaffold(
        body: ListView(
      //padding: EdgeInsets.all(edge_padding),
      children: <Widget>[
        NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mapPage()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => listPage(
                      lostObjects: widget.lostObjects, 
                      foundObjects: widget.foundObjects,
                      displayLostItems: true
                )));
              }
            });
          },
          //selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.explore),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.format_list_numbered),
              label: 'List',
            ),
          ],
        ),
        // Header
        Container(
          padding: EdgeInsets.all(edge_padding),
          decoration: separatorBoxDecoration(),
          height: 0.13 * dim_y,
          child: ListView(children: <Widget>[
            headerItem(Icons.local_offer,
                "   Item: " + widget.item.itemName.toString()),
            headerPadding(dim_y),
            headerItem(Icons.access_time, "   X hr : min ago"),
          ]),
        ),
        // Image
        Container(
            decoration: separatorBoxDecoration(),
            padding: EdgeInsets.all(widget_padding),
            height: 0.3 * dim_y,
            child: Text("Image of the item")
            //child: Image.network(widget.item.picture.toString())),
            ),
        // Description
        //Padding(padding: EdgeInsets.all(widget_padding)),
        Container(
            padding: EdgeInsets.all(widget_padding),
            height: 0.3 * dim_y,
            // Description text
            child: ListView(children: [
              Text("Description:", style: getStyle(18, true)),
              Text(widget.item.description.toString() + "\n",
                  style: getStyle(14, false)),
              Text("Contact Information:", style: getStyle(18, true)),
              Text(widget.item.phone.toString(), style: getStyle(14, false))
            ]))
      ],
    ));
  }
}

BoxDecoration separatorBoxDecoration() {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.blueAccent,
        width: 3.0,
      ),
    ),
  );
}

Padding headerPadding(var dim_y) {
  var header_row_spacing = 0.005 * dim_y;
  return Padding(padding: EdgeInsets.all(header_row_spacing));
}

Container headerItem(IconData icon, String text) {
  return Container(
    //decoration: separatorBoxDecoration(),
    child: Row(
      children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 44, 14, 192),
          size: 30.0,
        ),
        Text(text, style: getStyle(14, true)),
      ],
    ),
  );
}

TextStyle getStyle(double size, bool bold) {
  var f;
  if (bold) {
    f = FontWeight.bold;
  } else {
    f = FontWeight.normal;
  }
  return TextStyle(fontWeight: f, fontSize: size);
}
