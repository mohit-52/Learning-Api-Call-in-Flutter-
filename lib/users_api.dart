import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/UserModel.dart';

class UserApi extends StatefulWidget {
  const UserApi({Key? key}) : super(key: key);

  @override
  State<UserApi> createState() => _UserApiState();
}

class _UserApiState extends State<UserApi> {
  List<UserModel> userList = [];

  Future<List<UserModel>> getUsersList() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        userList.add(UserModel.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API HOST"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getUsersList(),
                  builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                child: Column(
                                  children: [
                                    ReusableRow(
                                      title: "Name: ",
                                      value:
                                          snapshot.data![index].name.toString(),
                                    ),
                                    ReusableRow(
                                      title: "UserName: ",
                                      value: snapshot.data![index].username
                                          .toString(),
                                    ),
                                    ReusableRow(
                                      title: "Email: : ",
                                      value: snapshot.data![index].email
                                          .toString(),
                                    ),
                                    ReusableRow(
                                      title: "Address: : ",
                                      value: snapshot
                                              .data![index].address!.street
                                              .toString() +
                                          ", " +
                                          snapshot.data![index].address!.suite
                                              .toString() +
                                          ", " +
                                          snapshot.data![index].address!.city
                                              .toString() +
                                          ", " +
                                          snapshot.data![index].address!.zipcode
                                              .toString() +
                                          "\n Latitude: " +
                                          snapshot
                                              .data![index].address!.geo!.lat
                                              .toString() +
                                          ", Longitude: " +
                                          snapshot
                                              .data![index].address!.geo!.lng
                                              .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }))
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;

  const ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(width: 40,),
          Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
            value,
            style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
          ),
              ))
        ],
      ),
    );
  }
}
