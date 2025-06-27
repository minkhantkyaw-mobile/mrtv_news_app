import 'package:mrtv_new_app_sl/services/response_object.dart';

abstract class HttpProvider {
  Future<ResponseObject> getRequest(
    String endPoint, {
    Map<String, dynamic>? params,
  });
}
