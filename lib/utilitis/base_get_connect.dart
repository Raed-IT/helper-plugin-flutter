import 'package:get/get.dart';

import '../mixings/api/check_response.dart';
import 'constats.dart';

class BaseGetConnect extends GetConnect with CheckResponseMixin {
  BaseGetConnect() {
    // httpClient.baseUrl = GlobalApiRouts.HOST;
    httpClient.timeout = Duration(seconds: 8);
    httpClient.addRequestModifier<dynamic>((request) {
      print("BaseGetConnect get url ==>  ${request.url}");
      request.headers['Authorization'] =
      "Bearer ${ConstantHelperMadaFlutter.token}";
      request.headers['Accept'] = "application/json";
      // print(request.headers);
      return request;
    });
    httpClient.addResponseModifier<dynamic>(
          (request, response) {
        print("ResponseFromBaseGetConnect ==> ${response.body}");
        return checkResponse(response: response);
      },
    );
  }
}
