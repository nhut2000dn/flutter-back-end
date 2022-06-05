import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  static const String UID = "uid";
  static const String NAME = "name";
  static const String IMAGE = "image";
  static const String DESCRIPTION = "description";

  late String _id;
  late String _name;
  late String _image;
  late String _description;

//  getters
  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get description => _description;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    _description = snapshot[DESCRIPTION];
    _image = snapshot[IMAGE];
    _name = snapshot[NAME];
    _id = snapshot.id;
  }
}
