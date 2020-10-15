import 'dart:convert';
import 'package:dio/dio.dart';

class HttpService {
  final String URL = "http://192.168.0.100:5000/";
  Dio dio;
  HttpService() {
    dio = Dio();
  }

  Future getPhotos() async {
    try {
      Response response = await dio.get(URL + 'list');
      List responseJson = json.decode(response.data);
      return responseJson;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future postPhoto(img64) async {
    Response response = await dio.post(
      URL + 'upload',
      data: {
        "image": img64
      }
    );
  }

  Future getBase64Image(photoName) async {
    try {
      Response response = await dio.get(URL + 'photo/' + photoName);
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

}