import 'package:http/http.dart' as http;

class ApiServices {
  ///getUserData
  static Future<http.Response> getData({required String url}) async {
    try {
      final request = await http.get(Uri.parse(url));
      return request;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  ///postUserData
  static Future<http.Response> postData({
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
    required String url,
  }) async {
    try {
      final request = await http.get(Uri.parse(url));
      return request;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  ///updateUserData
  static Future<http.Response> updateData({
    required Map<String, dynamic> body,
    required Map<String, dynamic> headers,
    required String url,
  }) async {
    try {
      final request = await http.get(Uri.parse(url));
      return request;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
