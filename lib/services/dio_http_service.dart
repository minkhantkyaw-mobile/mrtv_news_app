import 'package:dio/dio.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/http_provider.dart';
import 'package:mrtv_new_app_sl/services/http_service.dart';
import 'package:mrtv_new_app_sl/services/response_object.dart';

class DioHttpService extends HttpProvider {
  late Dio dio;

  @override
  Future<ResponseObject> getRequest(
    String endPoint, {
    Map<String, dynamic>? params,
  }) async {
    dio = Dio();
    print("REsponse $baseUrl$endPoint");
    print("Params $params");

    try {
      final response = await dio.get(baseUrl + endPoint, data: params);
      if (response.statusCode == 200) {
        return ResponseObject(data: response.data, status: ApiStatus.success);
      } else {
        return ResponseObject(status: ApiStatus.unknownError);
      }
    } on DioException catch (e) {
      final resp = e.response;
      if (resp != null) {
        if (resp.statusCode! >= 400 && resp.statusCode! < 500) {
          return ResponseObject(status: ApiStatus.clientError);
        } else if (resp.statusCode! >= 500) {
          return ResponseObject(status: ApiStatus.serverError);
        }
      }
      print(e);
      return ResponseObject(status: ApiStatus.networkError);
    }
  }
}
