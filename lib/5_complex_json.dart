import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learning_api/models/ProductsModel.dart';

class ComplexJSONModel extends StatefulWidget {
  const ComplexJSONModel({Key? key}) : super(key: key);

  @override
  State<ComplexJSONModel> createState() => _ComplexJSONModelState();
}

class _ComplexJSONModelState extends State<ComplexJSONModel> {
  Future<ProductsModel> getProductsList() async {
    final response = await http.get(
        Uri.parse('https://webhook.site/28bcaba9-c8b2-4238-9f67-9d3ab65319ef'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return ProductsModel.fromJson(data);
    } else {
      return ProductsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API HOST"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<ProductsModel>(
              future: getProductsList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(snapshot.data!.data![index].shop!.name.toString()),
                              subtitle: Text(snapshot.data!.data![index].shop!.shopemail.toString()),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data!.data![index].shop!.image.toString()),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 1,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  snapshot.data!.data![index].images!.length,
                                  itemBuilder: (context, position) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.25,
                                        width: MediaQuery.of(context).size.width *
                                            0.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                    .data!
                                                    .data![index]
                                                    .images![position]
                                                    .url
                                                    .toString()), fit: BoxFit.cover)),
                                      ),
                                    );
                                  }),
                            ),
                            Icon(snapshot.data!.data![index].inWishlist! == true ? Icons.favorite : Icons.favorite_outline )
                          ],
                        );
                      });
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
