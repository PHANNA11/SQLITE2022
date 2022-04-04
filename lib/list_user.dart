import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_sqlite_2022/data/conn.dart';
import 'package:project_sqlite_2022/model/update_date_page.dart';
import 'package:project_sqlite_2022/model/userdata.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({Key? key}) : super(key: key);

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  late ConnectionDB db;
  late Future<List<User>> _list;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
    db = ConnectionDB();
    db.initializeDB().whenComplete(() async {
      setState(() {
        _list = db.getUser();
      });
    });
  }
  // Future getImage(){

  // }

  Future<void> _onRefresh() async {
    setState(() {
      _list = getList();
      Future.delayed(const Duration(seconds: 5));
    });
  }

  Future<List<User>> getList() async {
    return await db.getUser();
  }

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List User"),
      ),
      body: FutureBuilder<List<User>>(
        future: _list,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          } else {
            final items = snapshot.data ?? <User>[];
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  image = File(items[index].pic);
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(color: Colors.red),
                    key: ValueKey<int>(items[index].id),
                    onDismissed: (DismissDirection direc) async {
                      await ConnectionDB().deleteUser(items[index].id);
                    },
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePage(
                                  id: items[index].id,
                                  User: items[index].name,
                                  pass: items[index].password,
                                  pic: items[index].pic,
                                ),
                              ));
                        });
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(image!),
                          ),
                          title: Text(
                            items[index].name,
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle:
                              Text("User ID:" + items[index].id.toString()),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
