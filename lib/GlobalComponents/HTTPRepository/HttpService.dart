// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls
import 'package:amritwaterdelivery/GlobalComponents/HTTPRepository/Packages.dart';
import 'package:http/http.dart' as http;

class HttpService {
  late http.Client _client;
  bool isLoggedIn = false; // Flag to track login state
  //----------------------------------------------------------------------------//
  HttpService() {
    _client = http.Client();
  }

  // Method to log in (set flag to true)
  void login() {
    isLoggedIn = true;
    _client = http.Client(); // Create a new client when logging in
    if (kDebugMode) {
      print("============User logged in, HTTP requests enabled.");
    }
  }

  // Method to log out (set flag to false)
  void logout() {
    isLoggedIn = false;
    _client.close(); // Close client to stop HTTP requests
    if (kDebugMode) {
      print("============User logged out, HTTP requests disabled.");
    }
  }

  //----------------------------------------------------------------------------//
  void LogResponse(
    String method,
    String url,
    http.Response response, [
    Map<String, dynamic>? body,
  ]) {
    if (kDebugMode) {
      print(GlobalFlag.Response);
      print('---HTTP Response Log---');
      print('Method: $method');
      print('URL: $url');
      print('Status: ${response.statusCode}');
      if (body != null && body.isNotEmpty) {
        print('Request Body:');
        body.forEach((key, value) {
          if (kDebugMode) {
            print('$key: $value');
          }
        });
      } else {
        print('Request Body: None (empty or null)');
      }
      if (response.headers.isNotEmpty) print('Headers: ${response.headers}');
      if (response.body.isNotEmpty) print('Response Body: \n${response.body}');
      print('---End Response Log---');
    }
  }

  //----------------------------------------------------------------------------//
  Future<Map<String, dynamic>> Request({
    required String method,
    required String url,
    Map<String, dynamic>? body, // This is optional for GET requests
    Map<String, String>? headers,
    required BuildContext context,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    http.Response response;

    try {
      final uri = Uri.parse(url);
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(uri, headers: headers).timeout(timeout);
          break;
        case 'POST':
          // Ensure body is passed in POST requests
          response = await _client
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(timeout);
          break;
        case 'PUT':
          // Ensure body is passed in PUT requests
          response = await _client
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(timeout);
          break;
        default:
          throw UnsupportedError('HTTP method not supported: $method');
      }

      // Log the response and request body
      LogResponse(method, url, response, body);
      return ProcessResponse(context, response);
    } on SocketException {
      // Log and handle socket exception
      if (kDebugMode) {
        print('No internet connection.');
      }
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    } on TimeoutException {
      // Handle timeout exception
      /*GlobalFunction().PopupFailedAlert(context, "InternetNotConnected", "",
          "Request timed out. Please check your internet connection or try again later.");*/
      throw Exception('Request timed out.');
    } on HttpException {
      // Handle HTTP exception
      if (kDebugMode) {
        print('Failed to load data: HTTP Exception');
      }
      throw Exception('Failed to load data');
    } on FormatException {
      // Handle format exception
      if (kDebugMode) {
        print('Response format error.');
      }
      throw Exception('Bad response format');
    } catch (e) {
      // Log and handle other exceptions
      if (kDebugMode) {
        print('Unexpected error occurred: $e');
      }
      throw Exception('Unexpected error occurred: $e');
    }
  }

  //----------------------------------------------------------------------------//
  Map<String, dynamic> ProcessResponse(
    BuildContext context,
    http.Response response,
  ) {
    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      try {
        final body = response.body;
        if (body.isEmpty) {
          throw Exception('Empty response body');
        }
        return json.decode(body);
      } catch (e) {
        if (kDebugMode) {
          print('Response processing error: $e');
        }
        throw FormatException('Response format error: $e');
      }
    } else {
      return HandleHttpError(context, statusCode, response.body);
    }
  }

  //----------------------------------------------------------------------------//
  Map<String, dynamic> HandleHttpError(
    BuildContext context,
    int statusCode,
    String responseBody,
  ) {
    // Log the error instead of showing popups for minor issues
    if (kDebugMode) {
      print('HTTP Error - Status: $statusCode, Response: $responseBody');
    }

    switch (statusCode) {
      case 400:
        /*GlobalFunction().PopupFailedAlert(
            context, "Failed", "", "Bad request! Please try again.");*/
        throw Exception('Bad request: $responseBody');
      case 401:
      case 403:
        /*GlobalFunction()
            .PopupFailedAlert(context, "Failed", "", "Unauthorized Access");*/
        throw Exception('Unauthorized Access');
      case 404:
        /* GlobalFunction()
            .PopupFailedAlert(context, "Failed", "", "Resource not found!");*/
        throw Exception('Resource not found');
      case 502:
      case 500:
        /*GlobalFunction()
            .PopupFailedAlert(context, "Failed", "", "Internal Server Error!");*/
        throw Exception('Internal server error');
      default:
        // Avoid popup for unknown status codes, log instead
        if (kDebugMode) {
          print('Error: HTTP $statusCode');
        }
        throw Exception('Error: HTTP $statusCode');
    }
  }

  //--UploadImage---------------------------------------------------------------//
  Future<http.Response> UploadImage(
    BuildContext context,
    Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    File imageFile, // Ensure this is passed correctly
    String imageKey,
    Duration timeout,
    String Method,
  ) async {
    // Create a multipart request
    var request = http.MultipartRequest(Method, uri)
      ..headers.addAll(headers ?? {});

    // Add other form fields (if any)
    if (body != null) {
      body.forEach((key, value) {
        // Convert value to String before adding to the request fields
        request.fields[key] = value.toString();
      });
    }

    // Add the image to the request
    var image = await http.MultipartFile.fromPath(imageKey, imageFile.path);
    request.files.add(image);

    try {
      // Send the request and wait for the response with a timeout
      var response = await request.send().timeout(timeout);
      // Convert the response stream to a Response object
      return await http.Response.fromStream(response);
    } on TimeoutException {
      // Show error popup since it's critical for user feedback
      /*GlobalFunction().PopupFailedAlert(context, "InternetNotConnected", "",
          "Request timed out. Please check your internet connection or try again later.");*/
      throw Exception('Request timed out.');
    } on HttpException {
      // Log the exception
      if (kDebugMode) {
        print('Failed to load data: HTTP Exception');
      }
      throw Exception('Failed to load data');
    } on FormatException {
      if (kDebugMode) {
        print('Response format error.');
      }
      throw Exception('Bad response format');
    } catch (e) {
      // Catch other errors
      throw Exception('Error occurred: $e');
    }
  }

  //----------------------------------------------------------------------------//
  void dispose() {
    _client.close();
    if (kDebugMode) {
      print('HTTP Client disposed');
    }
  }
}
