import 'dart:math';

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
                                  builder: (context) => ListUserPage(),
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
}
