import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jourapothole/core/helpers/widget_helper.dart';
import 'package:path/path.dart' as p; // Assuming this works

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
      // GlobWidgetHelper.showToast(isSuccess: true, message: message);
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
    Map<String, String>? headers,
    required String url,
  }) async {
    try {
      final defaultHeaders = {'Content-Type': 'multipart/form-data'};
      // Merge provided headers, letting them override defaults if keys are the same
      final combinedHeaders = {...defaultHeaders, ...(headers ?? {})};

      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Add the body as form data
      request.fields['data'] = jsonEncode(body); // Add the "data" field

      // Add headers
      request.headers.addAll(combinedHeaders);

      print("Sending PATCH to URL: $url");
      print("With Headers: $combinedHeaders");
      print("With Body: ${jsonEncode(body)}"); // Log what's being sent

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Received Response Status: ${response.statusCode}");
      print("Received Response Body: ${response.body}");

      _handleResponseFeedback(response); // Show toast based on response
      return response;
    } catch (e) {
      print("API PATCH Error: $e");
      GlobWidgetHelper.showToast(
        isSuccess: false,
        message: 'Network error occurred: ${e.toString()}',
      );
      rethrow; // Rethrow to allow calling function to handle or be aware
    }
  }

  static Future<http.Response> sendMultipartData({
    required String url,
    required String method,
    Map<String, File>? files, // Made optional if you only send data
    Map<String, String>? data,
    Map<String, String>? headers,
  }) async {
    // Validate method
    final validMethods = ['POST', 'PATCH', 'PUT'];
    if (!validMethods.contains(method.toUpperCase())) {
      throw ArgumentError(
        'Invalid HTTP method: $method. Must be one of $validMethods.',
      );
    }
    if ((files == null || files.isEmpty) && (data == null || data.isEmpty)) {
      throw ArgumentError(
        'Both files and data cannot be empty for a multipart request.',
      );
    }

    try {
      var request = http.MultipartRequest(method.toUpperCase(), Uri.parse(url));

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add non-file data fields (text fields)
      // If your backend expects a field named 'data' containing a JSON string of your textual updates,
      // the caller (Controller) should prepare the `data` map like: {'data': json.encode(yourProfileUpdateObject)}
      if (data != null) {
        request.fields.addAll(data);
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          String fieldName = entry.key; // e.g., 'avatar', 'profile_image'
          File file = entry.value;
          String fileName = p.basename(file.path);

          var stream = http.ByteStream(file.openRead());
          var length = await file.length();

          // Determine content type for common image types
          MediaType? contentType;
          String extension = p.extension(fileName).toLowerCase();
          if (extension == '.jpg' || extension == '.jpeg') {
            contentType = MediaType('image', 'jpeg');
          } else if (extension == '.png') {
            contentType = MediaType('image', 'png');
          } else if (extension == '.gif') {
            contentType = MediaType('image', 'gif');
          } else if (extension == '.webp') {
            contentType = MediaType('image', 'webp');
          }
          // For other file types, you might need a more robust MIME type detection
          // or let the http package/server infer it.

          var multipartFile = http.MultipartFile(
            fieldName,
            stream,
            length,
            filename: fileName,
            contentType: contentType,
          );
          request.files.add(multipartFile);
        }
      }

      print('Sending multipart request ($method) to: $url');
      if (request.headers.isNotEmpty) print('Headers: ${request.headers}');
      if (request.fields.isNotEmpty) print('Fields: ${request.fields}');
      if (request.files.isNotEmpty) {
        print(
          'Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes, type: ${f.contentType})').join(', ')}',
        );
      }

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 90),
      );
      var response = await http.Response.fromStream(streamedResponse);

      print('Multipart Response Status Code ($method): ${response.statusCode}');
      print(
        'Multipart Response Body ($method): ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}',
      );

      return response;
    } on SocketException {
      print(
        'SocketException ($method): No Internet connection or server not reachable for $url',
      );
      throw Exception('No Internet connection or server not reachable.');
    } on TimeoutException {
      print('TimeoutException ($method): The request to $url timed out.');
      throw Exception('The request timed out. Please try again.');
    } on ArgumentError catch (e) {
      print('ArgumentError ($method) in sendMultipartData for $url: $e');
      rethrow;
    } catch (e) {
      print('Error ($method) in sendMultipartData for $url: $e');
      throw Exception('Failed to send multipart data: ${e.toString()}');
    }
  }
}
