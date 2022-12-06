import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';

import 'custom_exception.dart';


class ApiProvider {

  Future<dynamic> get(String url) async {
     HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    var responseJson;
    try {
      final response = await ioClient.get(url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> post(String url,
      {Map<String, dynamic> headers, body, encoding}) async {
        HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    var responseJson;
    try {
      final response = await ioClient.post(url, headers: headers, body: body, encoding: encoding);
      responseJson = response.body;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getHtml(String url) async {
     HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    var responseJson;
    try {
      final response = await ioClient.get(url);
      responseJson = response.body;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithHeader(String url, Map<String, String> header) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    var responseJson;
    try {
      final response = await ioClient.get(url, headers: header);
      responseJson = response.body;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}