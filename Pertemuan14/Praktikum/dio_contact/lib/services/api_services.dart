import 'package:dio/dio.dart';
import 'package:dio_contact/model/contact_model.dart';
import 'package:dio_contact/model/login_model.dart';
import 'package:flutter/material.dart';


class ApiServices {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://contactsapi-production.up.railway.app',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Iterable<ContactsModel>?> getAllContact() async {
    try {
      final response = await dio.get('/contacts');

      if (response.statusCode == 200) {
        final list = (response.data['data'] as List)
            .map((e) => ContactsModel.fromJson(e))
            .toList();
        return list;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response?.statusCode} - ${e.message}');
      return null;
    }
  }

  Future<ContactsModel?> getSingleContact(String id) async {
    try {
      final response = await dio.get('/contacts/$id');

      if (response.statusCode == 200) {
        return ContactsModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.response?.statusCode} - ${e.message}');
      return null;
    }
  }

  Future<ContactResponse?> postContact(ContactInput ct) async {
    try {
      debugPrint('POST Request URL: ${dio.options.baseUrl}/insert');
      debugPrint('POST Request Body: ${ct.toJson()}');

      final response = await dio.post('/insert', data: ct.toJson());

      debugPrint('POST Response Status: ${response.statusCode}');
      debugPrint('POST Response Data: ${response.data}');

      if (response.statusCode == 201) {
        return ContactResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.response?.statusCode} - ${e.message}');
      debugPrint('Error Response: ${e.response?.data}');
      debugPrint('Request URL: ${e.requestOptions.uri}');
      debugPrint('Request Method: ${e.requestOptions.method}');
      debugPrint('Request Headers: ${e.requestOptions.headers}');
      return null;
    }
  }

  Future<ContactResponse?> putContact(String id, ContactInput ct) async {
    try {
      final response = await dio.put('/contacts/$id', data: ct.toJson());

      if (response.statusCode == 200) {
        return ContactResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.response?.statusCode} - ${e.message}');
      return null;
    }
  }

  Future<ContactResponse?> deleteContact(String id) async {
    try {
      final response = await dio.delete('/contacts/$id');

      if (response.statusCode == 200) {
        return ContactResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.response?.statusCode} - ${e.message}');
      return null;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post('/login', data: login.toJson());
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
