
import 'package:get/get.dart';

class PaginationProvider extends GetConnect {
  Future<Response> getData({required String url}) => get(url);
}
