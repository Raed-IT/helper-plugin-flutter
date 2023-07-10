import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> checkInternet() async {
  return await InternetConnectionCheckerPlus().hasConnection;
}
