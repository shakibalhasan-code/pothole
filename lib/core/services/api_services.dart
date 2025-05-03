import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jourapothole/core/helpers/widget_helper.dart'; // Assuming this works

class ApiServices {
  // Helper to show toast based on status code
  static void _handleResponseFeedback(http.Response response) {
    // Decode body only if needed for the message or error details
    String message = 'Request failed';
    try {
      final body = jsonDecode(response.body);
      if (body != null && body is Map && body.containsKey('message')) {
        message = body['message'];
      } else {
        message =
            'Status: ${response.statusCode}'; // Default message if body has no 'message'
      }
    } catch (e) {
      message =
          'Status: ${response.statusCode}'; // Fallback if body is not JSON or null
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      GlobWidgetHelper.showToast(isSuccess: true, message: message);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Error (${response.statusCode}): $message',
      );
    } else {
      // 5xx or other unexpected codes
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Server Error (${response.statusCode}): $message',
      );
    }
  }

  /// getUserData
  static Future<http.Response> getData({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        throw FormatException("Invalid URL: $url");
      }

      final response = await http.get(uri, headers: headers ?? {});

      _handleResponseFeedback(response); // Custom feedback function

      return response;
    } on SocketException {
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'No Internet connection',
      );
      rethrow;
    } on TimeoutException {
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Request timed out',
      );
      rethrow;
    } on FormatException catch (e) {
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Invalid URL: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print("API GET Error: $e");
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Something went wrong',
      );
      rethrow;
    }
  }

  /// postUserData
  static Future<http.Response> postData({
    required Map<String, dynamic> body,
    required String url,
    Map<String, String>? headers, // Add headers parameter
  }) async {
    try {
      final defaultHeaders = {'Content-Type': 'application/json'};
      final combinedHeaders = {
        ...defaultHeaders,
        ...(headers ?? {}),
      }; // Combine default and passed headers

      final request = await http.post(
        Uri.parse(url),
        headers: combinedHeaders, // Use headers
        body: jsonEncode(body),
      );

      _handleResponseFeedback(request); // Show toast based on response
      return request; // <-- Return the http.Response object
    } catch (e) {
      print("API POST Error: $e"); // More specific logging
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Network error occurred',
      ); // Show network error toast
      rethrow;
    }
  }

  /// updateUserData
  static Future<http.Response> updateData({
    required Map<String, dynamic> body,
    Map<String, String>? headers, // Fix: Make headers optional if no auth
    required String url,
  }) async {
    try {
      final defaultHeaders = {'Content-Type': 'application/json'};
      final combinedHeaders = {
        ...defaultHeaders,
        ...(headers ?? {}),
      }; // Combine default and passed headers

      final request = await http.patch(
        Uri.parse(url),
        headers: combinedHeaders, // Fix: Use headers
        body: jsonEncode(body),
      );

      _handleResponseFeedback(request); // Show toast based on response
      return request; // <-- Return the http.Response object
    } catch (e) {
      print("API PATCH Error: $e"); // More specific logging
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Network error occurred',
      ); // Show network error toast
      rethrow;
    }
  }
}
