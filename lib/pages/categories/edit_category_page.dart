// ignore_for_file: deprecated_member_use
import 'dart:io' as io;
import 'dart:io';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/services/categories.dart';
import 'package:admin_dashboard/services/genre.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/loading_opacity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/widgets/page_header.dart';

// ignore: must_be_immutable
class EditCategoryPage extends StatefulWidget {
  Map<String, dynamic> argument;

  EditCategoryPage({
    Key? key,
    required this.argument,
  }) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

enum statusUploadImageAndEditCategory {
  sucess,
  fail,
  failUploadStorage,
  failAddFirestore
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final CategoryService _categoryService = CategoryService();
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;
  PickedFile? _imageFile = PickedFile('');
  final picker = ImagePicker();
  late bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.argument['name'];
    _descriptionController = TextEditingController();
    _descriptionController.text = widget.argument['description'];
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path != '') {
      setState(() {
        _imageFile = PickedFile(pickedFile.path);
      });
    }
  }

  Future<bool> editCategoryToFirebae(
      String id, String name, String description, String image) async {
    var imageObject = image != '' ? {'image': image} : {};
    if (name == '' || description == '') {
      return false;
    } else {
      return await _categoryService.updateCategory(id, {
        ...{
          'name': name,
          'description': description,
        },
        ...imageObject
      });
    }
  }

  Future<statusUploadImageAndEditCategory> uploadImageAndEditCategoryToFirebase(
      String id, String name, String description) async {
    statusUploadImageAndEditCategory status =
        statusUploadImageAndEditCategory.fail;
    if (_imageFile!.path != '') {
      String fileName = basename(_imageFile!.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('categories')
          .child('/$fileName');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': fileName});
      firebase_storage.UploadTask uploadTask;
      //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageF  ile);
      uploadTask = ref.putData(await _imageFile!.readAsBytes(), metadata);

      firebase_storage.UploadTask task = await Future.value(uploadTask);
      await Future.value(uploadTask)
          .then((value) async => {
                debugPrint(
                    "Upload file path ${await value.ref.getDownloadURL()}"),
                if (await editCategoryToFirebae(
                    id, name, description, await value.ref.getDownloadURL()))
                  {status = statusUploadImageAndEditCategory.sucess}
                else
                  {status = statusUploadImageAndEditCategory.failAddFirestore}
              })
          .onError((error, stackTrace) => {
                debugPrint("Upload file path error ${error.toString()} "),
                status = statusUploadImageAndEditCategory.failUploadStorage
              });
    } else {
      if (await editCategoryToFirebae(id, name, description, '')) {
        status = statusUploadImageAndEditCategory.sucess;
      } else {
        status = statusUploadImageAndEditCategory.failAddFirestore;
      }
    }

    debugPrint(status.toString());
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return Stack(
      children: [
        Opacity(
          opacity: _isLoading
              ? 0.5
              : 1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                    text: 'EDIT CATEGORY',
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(
                      maxHeight: 600,
                      maxWidth: 700,
                    ),
                    child: Card(
                      elevation: 1,
                      shadowColor: Colors.black,
                      clipBehavior: Clip.none,
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  color: const Color(0xffFFFFFF),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Name: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextField(
                                                      controller:
                                                          _nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter name you want',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Description: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextField(
                                                      controller:
                                                          _descriptionController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter Description of genre',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Image: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Stack(
                                              fit: StackFit.loose,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 150.0,
                                                      height: 150.0,
                                                      child: CircleAvatar(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: AspectRatio(
                                                            aspectRatio: 1,
                                                            child: (_imageFile!
                                                                        .path ==
                                                                    '')
                                                                ? (widget.argument[
                                                                            'image'] !=
                                                                        '')
                                                                    ? FadeInImage
                                                                        .assetNetwork(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            'images/loading.gif',
                                                                        image: widget
                                                                            .argument['image'],
                                                                      )
                                                                    : const Image(
                                                                        image: AssetImage(
                                                                            'images/no_image.jpg'),
                                                                      )
                                                                : (kIsWeb)
                                                                    ? Image.network(
                                                                        _imageFile!
                                                                            .path)
                                                                    : Image(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: FileImage(
                                                                            io.File(_imageFile!.path))),
                                                          ),
                                                        ),
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 150.0,
                                                  height: 150.0,
                                                  child: InkWell(
                                                    onTap: pickImage,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 90.0,
                                                              left: 90),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const <
                                                            Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            radius: 25.0,
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _getActionButtons(context, tablesProvider)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Opacity(
            opacity: _isLoading ? 1.0 : 0,
            child: _isLoading ? const LoadingOpacity() : Container()),
      ],
    );
  }

  Widget _getActionButtons(
      BuildContext context, TablesProvider tablesProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.indigo),
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      statusUploadImageAndEditCategory status =
                          await uploadImageAndEditCategoryToFirebase(
                        widget.argument['id'],
                        _nameController.text,
                        _descriptionController.text,
                      );
                      if (status == statusUploadImageAndEditCategory.sucess) {
                        locator<NavigationService>().goBack();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Update Category Succesful!")));
                        tablesProvider.refreshFromFirebase(Tables.categories);
                      } else if (status ==
                          statusUploadImageAndEditCategory.failUploadStorage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Upload Category failed!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Update Category failed! Invalid form")));
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: "SAVE",
                            size: 22,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Container(
                decoration: const BoxDecoration(color: Colors.redAccent),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      locator<NavigationService>().goBack();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CustomText(
                          text: "CANCEL",
                          size: 22,
                          color: Colors.white,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
