import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_sqlite_2022/data/conn.dart';
import 'package:project_sqlite_2022/list_user.dart';
import 'package:project_sqlite_2022/model/userdata.dart';

class UpdatePage extends StatefulWidget {
  UpdatePage(
      {required this.id, required this.User, required this.pass, Key? key})
      : super(key: key);

  String User;
  int id;
  String pass;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int _counter = 0;
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerUser.text = widget.User;
    controllerPass.text = widget.pass;
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
                                password: controllerPass.text.trim()))
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
