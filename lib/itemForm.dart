import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class itemForm extends StatefulWidget {
  const itemForm({super.key});

  @override
  State<itemForm> createState() => _itemFormState();
}

class _itemFormState extends State<itemForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text("Please Enter Your Item"),
                FormBuilderTextField(name: "Description of Item", initialValue: "Description of Item",),
                FormBuilderTextField(name: "Phone Number"),
                ElevatedButton(onPressed: () => null, child: Text('Submit'))
                
                ],
            )));
  }
}
