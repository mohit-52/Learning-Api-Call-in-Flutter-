import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  getImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {

      });
    } else {
      print("No image selected");
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var stream =  http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    
    var uri = Uri.parse('http://fakestoreapi.com/products');

    var request  =  http.MultipartRequest('POST', uri);

    request.fields['title'] = 'Static Title';

    var multiPort = http.MultipartFile('image', stream, length);

    request.files.add(multiPort);

    var response = await request.send();

    if(response.statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      print("Image Uploaded!");
    }else{
      setState(() {
        showSpinner = false;
      });
      print("Failed to upload image!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Image API Server'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: image == null ? GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: const Center(child: Text("Pick A Image"))) :

              Container(
                child: Center(
                  child: Image.file(
                    File(image!.path).absolute,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100,),
            GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: const Center(child: Text("UPLOAD"),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
