import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:project_sqlite_2022/data/conn.dart';
import 'package:project_sqlite_2022/list_user.dart';
import 'package:project_sqlite_2022/model/userdata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _base64Image;
  late File _image;
  // ignore: unused_field
  late Uint8List _bytesImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          // ignore: unnecessary_null_comparison
                          image: NetworkImage('url'),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    height: 40,
                    width: 40,
                    child: InkWell(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: Container(
                              height: 120,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('data'),
                                  // ListTileWidget(
                                  //     icon: (Icons.linked_camera_sharp),
                                  //     label: 'Select Camera',
                                  //     onTap: () {
                                  //       _openCamera();
                                  //     }),
                                  // ListTileWidget(
                                  //     icon: (Icons.collections),
                                  //     label: 'Select Phone',
                                  //     onTap: () {
                                  //       _openGallery();
                                  //     }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                          height: 80,
                          width: 80,
                          //  color: Colors.red,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 35,
                          )),
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: controllerUser,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Enter Username";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Enter username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: controllerPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Enter password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await ConnectionDB()
                            .insertUser(User(
                                id: Random().nextInt(100),
                                name: controllerUser.text.trim(),
                                password: controllerPass.text.trim()))
                            .whenComplete(
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListUserPage(),
                                ),
                              ),
                            );
                        print('insert Success');
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Processing Data Insert')));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Processing Data Insert'),
                        ));
                      }
                    },
                    child: const Text('Save')),
              ))
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _openGallery() async {
    // ignore: deprecated_member_use

    // var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    // List<int> imageBytes = image2.readAsBytesSync();
    // _base64Image = base64Encode(imageBytes);
    // _bytesImage = const Base64Decoder().convert(_base64Image);
    // setState(() => _image = image2);
  }

  Future<void> _openCamera() async {
    // // ignore: deprecated_member_use
    // var image2 = await ImagePicker.pickImage(source: ImageSource.camera);
    // List<int> imageBytes = image2.readAsBytesSync();
    // _base64Image = base64Encode(imageBytes);
    // _bytesImage = const Base64Decoder().convert(_base64Image);
    // setState(() => _image = image2);
  }
}
