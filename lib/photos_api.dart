import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotosApi extends StatefulWidget {
  const PhotosApi({Key? key}) : super(key: key);

  @override
  State<PhotosApi> createState() => _PhotosApiState();
}

class _PhotosApiState extends State<PhotosApi> {
  List<Photos> photosList = [];

  Future<List<Photos>> getPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']);
        photosList.add(photos);
      }
      return photosList;
    } else {
      return photosList;
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
          Expanded(
            child: FutureBuilder(
                future: getPhotos(),
                builder: (context, AsyncSnapshot<List<Photos>> snapShot) {
                  return ListView.builder(
                      itemCount: photosList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapShot.data![index].url.toString()),
                              ),
                              title: Text(snapShot.data![index].title.toString()),
                              subtitle: Text(snapShot.data![index].id!.toString()),
                            ),
                          ),
                        );
                      });
                }),
          ),

        ],
      ),
    );
  }
}

class Photos {
  String title, url;
  int id;

  Photos({required this.title, required this.url, required this.id});
}
