import 'package:flutter/material.dart';
import 'package:lost_found_steelhacks/lostAndFoundObject.dart';
import 'package:lost_found_steelhacks/postPage.dart';
import 'package:lost_found_steelhacks/mapPage.dart';

class listPage extends StatefulWidget {
  final double spacing = 10;
  final double border_radius = 5;
  final List<LostAndFoundObject> lostObjects;
  final List<LostAndFoundObject> foundObjects;
  final bool displayLostItems;
  const listPage(
      {super.key,
      required this.lostObjects,
      required this.foundObjects,
      required this.displayLostItems});

  List<LostAndFoundObject> getEntries() {
    return lostObjects;
  }

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  Widget build(BuildContext context) {
    List<Widget> components = [];
    components.add(NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => mapPage()));
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => listPage(
                        lostObjects: widget.lostObjects,
                        foundObjects: widget.foundObjects,
                        displayLostItems: !widget.displayLostItems)));
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
    ));
    components.addAll(get_list_entries());
    return Scaffold(body: ListView(children: components));
  }

  List<Widget> get_list_entries() {
    List<Widget> containers = [];
    List<LostAndFoundObject> objects = widget.displayLostItems ? widget.lostObjects : widget.foundObjects;
    for (LostAndFoundObject e in objects) {
      // Padding
      //containers.add(Padding(padding: EdgeInsets.all(widget.spacing)));
      // Entry
      containers.add(InkWell(
          child: Container(
              height: 100,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 0, 0, 0), width: 5)),
              child: ListView(children: [
                Text("Item: " + e.itemName.toString()),
                Text("Contact: " + e.phone.toString()),
                Text(e.description.toString())
              ])),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostPage(
                        item: e,
                        lostObjects: widget.lostObjects,
                        foundObjects: widget.foundObjects
                )));
          }));
    }
    ;
    return containers;
  }
}
