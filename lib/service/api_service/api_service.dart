import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:marine_media_enterprises/core/database/app_preferences.dart';

import 'api_url.dart';

class ApiService {
  Uri _getUri(String endpoint) {
    return Uri.parse('${ApiUrl.baseUrl}$endpoint');
  }

  Future<String> _accessToken() async {
    AppPreferences appPreferences = AppPreferences();
    final String? token = await appPreferences.getAccessToken();
    return token ?? "";
  }

  Future<Map<String, String>> _headers() async {
    final token = await _accessToken();
    print("Access Token: $token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<http.Response> _sendRequest(
      Future<http.Response> Function() requestFunc, Uri uri,
      {dynamic body}) async {
    try {
      _logRequest(uri, body);
      final response = await requestFunc();
      _logResponse(uri, response);
      if (_isUnauthorized(response.statusCode)) {
        _handleUnauthorizedAccess();
      }
      return response;
    } catch (e) {
      log("Error during API call to $uri: $e");
      rethrow;
    }
  }

  void _logRequest(Uri uri, dynamic body) {
    log("Request URL: $uri");
    if (body != null) log("Request Body: ${jsonEncode(body)}");
  }

  void _logResponse(Uri uri, http.Response response) {
    log("Response for URL: $uri");
    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
  }

  bool _isUnauthorized(int statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  void _handleUnauthorizedAccess() {
    log("Unauthorized access detected.");
  }

  Future<http.Response> get(String endpoint) async {
    Uri uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    return _sendRequest(() => http.get(uri, headers: headers), uri);
  }

  Future<http.Response> post(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    Uri uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    return _sendRequest(
            () => http.post(uri, headers: headers, body: jsonEncode(body)), uri,
        body: body);
  }

  Future<http.Response> put(String endpoint, dynamic body) async {
    Uri uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    return _sendRequest(
            () => http.put(uri, headers: headers, body: jsonEncode(body)), uri,
        body: body);
  }

  Future<http.Response> patch(String endpoint, dynamic body) async {
    Uri uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    return _sendRequest(
            () => http.patch(uri, headers: headers, body: jsonEncode(body)), uri,
        body: body);
  }

  Future<http.Response> delete(String endpoint, {dynamic body}) async {
    Uri uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    return _sendRequest(
            () => http.delete(uri, headers: headers, body: jsonEncode(body)), uri,
        body: body);
  }

  Future<http.Response> uploadImage(
      {String? imagePath, Map<String, String>? data, endpoint}) async {
    final uri = _getUri(endpoint);
    Map<String, String> headers = await _headers();
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(data!);

    // for (var img in imagePath!) {
    //   print("Image Path: ${img.path}");
    //   request.files
    //       .add(await http.MultipartFile.fromPath('image[]', img.path ?? ""));
    // }

    if(imagePath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', imagePath));
    }


    request.headers.addAll(headers);

    //_logRequest(uri, {"imagePath": imagePath});

    // _logRequest(uri, {
    //   "imagePaths": imagePath?.map((xfile) => xfile.path).toList(),
    // });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    _logResponse(uri, response);

    return response;
  }
}
