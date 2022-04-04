import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
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
  File? _image;
  // ignore: unused_field
  late Uint8List _bytesImage;
  @override
  Widget build(BuildContext context) {
    // ===== Funtion Camera and gallary ====

    Future getImagefromCamera() async {
      final image = await ImagePicker.platform
          .pickImage(source: ImageSource.camera, imageQuality: 100);

      setState(() {
        _image = File(image!.path);
      });
    }

    Future getImagefromaGallary() async {
      final image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
    }

    //==== Function Alert Dialog ====
    Future<void> _showDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Builder(
                      builder: (context) {
                        return const Divider(
                          color: Colors.blueAccent,
                          height: 2,
                        );
                      },
                    ),
                    ListTile(
                      onTap: () {
                        getImagefromaGallary();
                        Navigator.pop(context);
                      },
                      subtitle: const Text('Gallary'),
                    ),
                    const Divider(
                      color: Colors.pinkAccent,
                      height: 2,
                    ),
                    ListTile(
                      onTap: () {
                        getImagefromCamera();
                        Navigator.pop(context);
                      },
                      subtitle: const Text('Camera'),
                    )
                  ],
                ),
              ),
            );
          });
    }

    //==========================
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
                        //image: AssetImage(assetName)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: _image == null
                            ? Image.asset('assets/images/boy.png')
                            : Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      height: 40,
                      width: 40,
                      child: Container(
                          height: 80,
                          width: 80,
                          //  color: Colors.red,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 35,
                            ),
                            onPressed: () {
                              setState(() {
                                _showDialog(context);
                              });
                            },
                          )),
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
                          // var tempItem = upload();
                          if (_formKey.currentState!.validate()) {
                            await ConnectionDB()
                                .insertUser(User(
                                    id: Random().nextInt(100),
                                    name: controllerUser.text.trim(),
                                    password: controllerPass.text.trim(),
                                    pic: _image!.path))
                                .whenComplete(
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ListUserPage(),
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
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Container(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ListUserPage()))
                            .whenComplete(() => this);
                      },
                      child: const Text('View List')),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
