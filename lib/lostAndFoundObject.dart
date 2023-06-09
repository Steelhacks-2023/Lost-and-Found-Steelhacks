import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LostAndFoundObject {
  final String? itemName;
  final String? description;
  final num? phone;
  final int? picture;
  final GeoPoint? location;

  LostAndFoundObject(
      {this.itemName,
      this.description,
      this.phone,
      this.picture,
      this.location});

  factory LostAndFoundObject.fromFirestore(
    QueryDocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    //final data = snapshot.data();
    return LostAndFoundObject(
        itemName: snapshot.get('ItemName'),
        description: snapshot.get('Description'),
        location: snapshot.get('Location'),
        phone: snapshot.get('Phone'),
        picture: snapshot.get('Picture'));
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (itemName != null) "name": itemName,
      if (description != null) "description": description
    };
  }
}
