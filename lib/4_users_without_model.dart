import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiWithoutModel extends StatefulWidget {
  const UserApiWithoutModel({Key? key}) : super(key: key);

  @override
  State<UserApiWithoutModel> createState() => _UserApiWithoutModelState();
}

class _UserApiWithoutModelState extends State<UserApiWithoutModel> {

  var data;

  Future<void> getUserList() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

        if(response.statusCode == 200){
          data = jsonDecode(response.body.toString());
        }else{

        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API HOST"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
            future: getUserList(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else{
            return ListView.builder(
              itemCount: data.length,
                itemBuilder: (context, index){
              return Card(
                child: Column(
                  children: [
                    ReusableRow(title: "Name: " ,value: data[index]['name'].toString(),),
                    ReusableRow(title: "Username: " ,value: data[index]['username'].toString(),),
                    ReusableRow(title: "Address: " ,value: data[index]['address']['street'].toString(),),
                    ReusableRow(title: "Latitude: " ,value: data[index]['address']['geo']['lat'].toString(),),
                  ],
                ),
              );
            });
              }
          },))
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
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(width: 40,),
          Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ))
        ],
      ),
    );
  }
}

