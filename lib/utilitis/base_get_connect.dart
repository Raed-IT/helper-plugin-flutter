import 'package:get/get.dart';

import '../mixings/api/check_response.dart';
import 'constats.dart';

class BaseGetConnect extends GetConnect with CheckResponseMixin {
  BaseGetConnect() {
    httpClient.timeout = Duration(seconds: 8);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] =
          "Bearer ${ConstantHelperMadaFlutter.token}";
      request.headers['Accept'] = "application/json";
      return request;
    });
    httpClient.addResponseModifier<dynamic>(
      (request, response) {
        return checkResponse(response: response);
      },
    );
  }
}
