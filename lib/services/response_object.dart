import 'package:mrtv_new_app_sl/services/api_state.dart';

class ResponseObject {
  final dynamic data;
  final ApiStatus status;

  ResponseObject({this.data, required this.status});
}
