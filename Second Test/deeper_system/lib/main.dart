import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'http_service.dart';
import 'http_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deeper Systems',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var photos = null;
  Future getPhotos() async {
    setState(() {
      photos = null;
    });
    var p = await HttpService().getPhotos();
    setState(() {
      photos = p;
    });
  }

  void _configurandoModalBottomSheet(context, photoName) async {
    final base64 = await HttpService().getBase64Image(photoName);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.memory(base64Decode(base64)),
          actions: <Widget>[ ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deeper Systems Test"),
      ),
      body: Container(
        child: photos != null ?
          RefreshIndicator(
            child: ListView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    photos[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black
                    )
                  ),
                  trailing: Icon(Icons.remove_red_eye_outlined),
                  onTap: () {
                    // print(photos[index]);
                    _configurandoModalBottomSheet(context, photos[index]);
                  },
                );
              }
            ),
            onRefresh: getPhotos
          ) :
          Center(child: CircularProgressIndicator())
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final pickedFile = await _picker.getImage(source: ImageSource.camera);
          final bytes = File(pickedFile.path).readAsBytesSync();
          String img64 = base64Encode(bytes);

          try {
            await HttpService().postPhoto(img64);
            getPhotos();
          } catch (e) {
            print(e);
          }
        },
        tooltip: 'New photo',
        child: Icon(Icons.add),
      ),
    );
  }
}
