import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_sqlite_2022/data/conn.dart';
import 'package:project_sqlite_2022/list_user.dart';
import 'package:project_sqlite_2022/model/userdata.dart';

class UpdatePage extends StatefulWidget {
  UpdatePage(
      {required this.id,
      required this.User,
      required this.pass,
      required this.pic,
      Key? key})
      : super(key: key);

  String User;
  int id;
  String pass;
  String pic;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int _counter = 0;
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerUser.text = widget.User;
    controllerPass.text = widget.pass;
    _image = File(widget.pic);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Update User'),
      ),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // child: Padding(
                    //   padding: const EdgeInsets.all(3),
                    //   child: _image == null
                    //       ? Image.asset('assets/images/boy.png')
                    //       : Image.file(
                    //           File(_image!.path),
                    //           fit: BoxFit.cover,
                    //         ),
                    // ),
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
                      if (_formKey.currentState!.validate()) {
                        await ConnectionDB()
                            .updateUser(User(
                                id: widget.id,
                                name: controllerUser.text.trim(),
                                password: controllerPass.text.trim(),
                                pic: widget.pic))
                            .whenComplete(() => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListUserPage(),
                                ),
                                (route) => false));
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
                    child: const Text('Update')),
              ))
            ],
          ),
        ),
      )),
    );
  }
}
