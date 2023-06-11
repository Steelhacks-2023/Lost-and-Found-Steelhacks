//import 'dart:html';
import 'dart:io';

//import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_steelhacks/mapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

CollectionReference lost = FirebaseFirestore.instance.collection('Lost');
CollectionReference found = FirebaseFirestore.instance.collection('Found');

const List<String> list = <String>[
  'Water Bottle',
  'ID',
  'Wallet',
  'Phone',
  'Coat',
  'Other'
];
final numberCheck =
    RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
final List<bool> isSelected = <bool>[true, false];
String description = "", category = "Water Bottle";
int phone = 0;
LatLng local = LatLng(0, 0);
double lat = 0, long = 0;

const List<Widget> options = <Widget>[
  Text('Lost'),
  Text('Found'),
];
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const SwitchApp());
// }

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    File imageUrl;
    return Form(
        key: _formKey,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //SwitchExample(),
            const Text('Enter your item from: ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Text(("N: " + lat.toString() + " \nS: " + long.toString() + "\n"),
                style: TextStyle(
                  fontSize: 18,
                )),

            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              children: options,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: DropdownButt(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: TextBox(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: PhoneNumber(),
            ),

            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      ),
                ],
              ),
            ),
            UploadImageButton(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ButtonTheme(
                minWidth: 150,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      //this is where the form stuff is grabbed
                      print(category);
                      print(description);
                      print(phone);

                      if (isSelected[0]) {
                        addLost();
                      } else {
                        addFound();
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const mapPage()));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Description of Lost Item',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          description = value;
        }
        return null;
      },
    ));
  }
}

class PhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty || !numberCheck.hasMatch(value)) {
          return 'Please enter a valid phone number';
        } else {
          phone = int.parse(value.replaceAll('-', ''));
        }
        return null;
      },
    );
  }
}

class DropdownButt extends StatefulWidget {
  const DropdownButt({super.key});
  @override
  State<DropdownButt> createState() => _DropdownButtState();
}

class _DropdownButtState extends State<DropdownButt> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      alignment: Alignment.center,
      value: dropdownValue,
      borderRadius: BorderRadius.circular(14),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          category = dropdownValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({super.key});

  @override
  State<UploadImageButton> createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Upload Image"),
      onPressed: () {
        uploadImage();
      },
    );
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance.ref();
    String filePath = '';

    File file;

    if (kIsWeb) {
      var picked = await FilePicker.platform.pickFiles(type: FileType.image);

      if (picked != null) {
        file = File(picked.files.single.name);
        setState(() {
          var imageUrl = file;
        });
        try {
          await _firebaseStorage.putFile(file);
        } on Exception catch (_, e) {
          print("HI");
        }
      }
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.absolute}';
      file = File(filePath);

      await _firebaseStorage.putFile(file);
    }
  }
}

Future<void> addLost() {
  // Calling the collection to add a new user
  return lost
      //adding to firebase collection
      .add({
    //Data added in the form of a dictionary into the document.
    'Description': description,
    'ItemName': category,
    'Location': GeoPoint(lat, long),
    'Phone': phone,
    'Picture': 0
  });
}

Future<void> addFound() {
  // Calling the collection to add a new user
  return found
      //adding to firebase collection
      .add({
    //Data added in the form of a dictionary into the document.
    'Description': description,
    'ItemName': category,
    'Location': GeoPoint(lat, long),
    'Phone': phone,
    'Picture': 0
  });
}
