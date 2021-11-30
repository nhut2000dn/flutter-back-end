// ignore_for_file: deprecated_member_use
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/models/novels.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/slideshows.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/loading_opacity.dart';
import 'package:admin_dashboard/widgets/page_header.dart';

// ignore: must_be_immutable
class EditSlideshowPage extends StatefulWidget {
  Map<String, dynamic> argument;

  EditSlideshowPage({
    Key? key,
    required this.argument,
  }) : super(key: key);

  @override
  _EditSlideshowPageState createState() => _EditSlideshowPageState();
}

enum statusUploadImageAndUpdateSlideshow {
  sucess,
  fail,
  failUploadStorage,
  failAddFirestore
}

class _EditSlideshowPageState extends State<EditSlideshowPage> {
  final SlideshowService _slideshowService = SlideshowService();
  late TextEditingController _indexController;
  late TextEditingController _titleController;
  PickedFile? _imageFile = PickedFile('');
  final picker = ImagePicker();
  late bool _isLoading = false;
  NovelModel? novelCurrent;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.text = widget.argument['title'];
    _indexController = TextEditingController();
    _indexController.text = widget.argument['index'].toString();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path != '') {
      setState(() {
        _imageFile = PickedFile(pickedFile.path);
      });
    }
  }

  Future<bool> updateSlideshowToFirebae(
      String id, String title, String image, int index, String novelId) async {
    var imageObject = image != '' ? {'image': image} : {};
    return await _slideshowService.updateSlideshow(id, {
      ...{'title': title, 'index': index, 'novel_id': novelId},
      ...imageObject
    });
  }

  Future<statusUploadImageAndUpdateSlideshow>
      uploadImageAndUpdateGenreToFirebase(
          String id, String title, int index, String novelId) async {
    statusUploadImageAndUpdateSlideshow status =
        statusUploadImageAndUpdateSlideshow.fail;
    if (_imageFile!.path != '') {
      String fileName = basename(_imageFile!.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('slideshows')
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
                if (await updateSlideshowToFirebae(id, title,
                    await value.ref.getDownloadURL(), index, novelId))
                  {status = statusUploadImageAndUpdateSlideshow.sucess}
                else
                  {
                    status =
                        statusUploadImageAndUpdateSlideshow.failAddFirestore
                  }
              })
          .onError((error, stackTrace) => {
                debugPrint("Upload file path error ${error.toString()} "),
                status = statusUploadImageAndUpdateSlideshow.failUploadStorage
              });
    } else {
      if (await updateSlideshowToFirebae(id, title, '', index, novelId)) {
        status = statusUploadImageAndUpdateSlideshow.sucess;
      } else {
        status = statusUploadImageAndUpdateSlideshow.failAddFirestore;
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
                    text: 'EDIT SLIDESHOW',
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
                                              'Title: ',
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
                                                          _titleController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter title you want',
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
                                              'Index sort: ',
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
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _indexController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter index of slideshow',
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
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Novel: ',
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
                                                    child: DropdownButton(
                                                        isExpanded: true,
                                                        value: novelCurrent ??
                                                            (novelCurrent = tablesProvider
                                                                .novels
                                                                .where((element) =>
                                                                    element
                                                                        .id ==
                                                                    widget.argument[
                                                                        'novel_id'])
                                                                .first),
                                                        items: tablesProvider
                                                            .novels
                                                            .map(
                                                              (value) =>
                                                                  DropdownMenuItem(
                                                                child: Text(
                                                                    value.name),
                                                                value: value,
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            novelCurrent = value
                                                                as NovelModel;
                                                          });
                                                          debugPrint(
                                                              value.toString());
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _getActionButtons(context, '', tablesProvider)
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
      BuildContext context, String id, TablesProvider tablesProvider) {
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
                      statusUploadImageAndUpdateSlideshow status =
                          await uploadImageAndUpdateGenreToFirebase(
                        widget.argument['id'],
                        _titleController.text,
                        int.parse(_indexController.text),
                        novelCurrent!.id,
                      );
                      if (status ==
                          statusUploadImageAndUpdateSlideshow.sucess) {
                        locator<NavigationService>().goBack();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Update Slideshow Succesful!")));
                        tablesProvider.refreshFromFirebase(Tables.slideshows);
                      } else if (status ==
                          statusUploadImageAndUpdateSlideshow
                              .failUploadStorage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Upload Image failed!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Update Slideshow failed!")));
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
