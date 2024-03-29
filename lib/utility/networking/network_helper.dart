import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/bloc/user/user_bloc.dart';
import '../constant_logic_validations.dart';
import '../enums.dart';
import 'package:http/http.dart' as http;

import 'endpoints.dart';

class HelperResponse {
  String response;
  ServicesResponseStatues servicesResponse;
  HelperResponse({this.response = '', required this.servicesResponse});

  HelperResponse copyWith({
    String? response,
    ServicesResponseStatues? servicesResponse,
  }) =>
      HelperResponse(
        response: response ?? this.response,
        servicesResponse: servicesResponse ?? this.servicesResponse,
      );
}

class NetworkHelpers {
  static Future<HelperResponse> postDataHelper({
    required String url,
    body = "",
    bool useUserToken = false,
    String crud = "POST",
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (useUserToken) {
        final userState = globalUserBloc.state;

        if (userState is UserLoggedState) {
          headers['Authorization'] = "Bearer ${userState.user.token}";
        }
      }

      var request;
      http.StreamedResponse response;

      request = http.Request(crud, Uri.parse(EndPoints.kMainUrl + url));
      request.headers.addAll(headers);
      request.body = body;

      response = await request.send();

      String streamRes = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }

      Map<String, dynamic> jsonError = json.decode(streamRes);

      if (response.statusCode == 401) {
        // deleteUserFromLocal();
        // globalNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        //     AppRoutes.welcome, (Route<dynamic> route) => false);
      }

      String? error() {
        dynamic tmp = jsonError["message"];
        if (tmp is String) {
          return tmp;
        }
        if (tmp is List) {
          return tmp.toString();
        }
      }

      return HelperResponse(
        response: error() ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
        servicesResponse: ServicesResponseStatues.networkError,
      );
    }
  }

  static Future<HelperResponse> postDataWithFile({
    required String url,
    required Map<String, String> body,
    bool useUserToken = false,
    List<File> files = const [],
    String crud = "POST",
    String keyName = "file",
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (useUserToken) {
        final userState = globalUserBloc.state;

        if (userState is UserLoggedState) {
          headers['Authorization'] = "Bearer ${userState.user.token}";
        }
      }

      var request =
          http.MultipartRequest(crud, Uri.parse(EndPoints.kMainUrl + url));

      request.headers.addAll(headers);

      request.fields.addAll(body);

      if (files.isNotEmpty) {
        for (var element in files) {
          request.files
              .add(await http.MultipartFile.fromPath(keyName, element.path));
        }
      }

      http.StreamedResponse response = await request.send();

      String streamRes = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }

      Map<String, dynamic> jsonError = json.decode(streamRes);

      String? error() {
        dynamic tmp = jsonError["message"];
        if (tmp is String) {
          return tmp;
        }
        if (tmp is List) {
          return tmp.toString();
        }
      }

      return HelperResponse(
        response: error() ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError);
    }
  }

  static Future<HelperResponse> getDeleteDataHelper({
    required String url,
    body = "",
    bool useUserToken = false,
    String crud = "GET",
  }) async {
    try {
      Map<String, String> headers;
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (useUserToken) {
        final userState = globalUserBloc.state;

        if (userState is UserLoggedState) {
          headers['Authorization'] = "Bearer ${userState.user.token}";
        }
      }

      var request = http.Request(crud, Uri.parse(EndPoints.kMainUrl + url));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String streamRes = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HelperResponse(
          response: streamRes,
          servicesResponse: ServicesResponseStatues.success,
        );
      }

      Map<String, dynamic> jsonError = json.decode(streamRes);

      //
      // if (response.statusCode == 401) {
      //   deleteUserFromLocal();
      //   globalNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      //       AppRoutes.welcome, (Route<dynamic> route) => false);
      // }

      String? error() {
        dynamic tmp = jsonError["message"];
        if (tmp is String) {
          return tmp;
        }
        if (tmp is List) {
          return tmp.toString();
        }
      }

      return HelperResponse(
        response: error() ?? response.reasonPhrase ?? "",
        servicesResponse: ServicesResponseStatues.someThingWrong,
      );
    } on SocketException catch (e) {
      return HelperResponse(
          servicesResponse: ServicesResponseStatues.networkError);
    }
  }
}
