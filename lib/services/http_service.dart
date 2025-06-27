import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/http_provider.dart';
import 'package:mrtv_new_app_sl/services/response_object.dart';

const String baseUrl = "https://mrtv.gov.mm/mrtvapi/";

class HttpService extends HttpProvider {
  // Not to endpoint
  // Yes to endPoint
  ///
  /// endPointParameter
  /// getRequestFromAnotherClass
  ///
  @override
  Future<ResponseObject> getRequest(
    String endPoint, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endPoint'));
      if (response.statusCode == 200) {
        return ResponseObject(
          data: jsonDecode(response.body),
          status: ApiStatus.success,
        );
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        return ResponseObject(status: ApiStatus.clientError);
      } else if (response.statusCode >= 500) {
        return ResponseObject(status: ApiStatus.serverError);
      } else {
        return ResponseObject(status: ApiStatus.unknownError);
      }
    } catch (e) {
      print(e);
      return ResponseObject(status: ApiStatus.networkError);
    }
  }
}
