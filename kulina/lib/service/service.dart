import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kulina/model/product.dart';
import 'package:kulina/shared/failure.dart';

class Service {

  static final Service _service = Service._internal();

  factory Service() {
    return _service;
  }

  Service._internal();


  static Future<Either<Failure,List<Product>>> getProduct({required int page}) async {

       final _url = Uri.tryParse("https://kulina-recruitment.herokuapp.com/products?_page=$page");

       log("Initiate the requesting");

     try{

      final response = await http.get(_url!);
      final decodedResponse = await statusCodeCheck(response);

      if (decodedResponse is Failure) {
        return Left(decodedResponse);
      }

      print(response.statusCode);
      log(response.body);

      List<Product> a = [];
      
      for(int i = 0; i < decodedResponse.length; i++){
         a.add(Product.fromJson(decodedResponse[i]));   
      }

       return Right(a);

     } on TimeoutException{
       return Left(Failure("Request Time-out"));
     } on SocketException {
       return Left(Failure("The connection has problem"));
     } catch (_){
        return left(Failure("Sorry, you have a problem"));
     } 
   }

  
  static Future<dynamic> statusCodeCheck(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 404:
        return Failure("Page not found");
      case 400:
        return Failure("Bad Request");
    }
  }
}