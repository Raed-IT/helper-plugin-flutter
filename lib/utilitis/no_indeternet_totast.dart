import 'package:fluttertoast/fluttertoast.dart';

bool isShowNoInternetToast = false;

showNoInternetToast() {
  if (!isShowNoInternetToast) {
    isShowNoInternetToast = true;
    Fluttertoast.showToast(msg: "تاكد من اتصالك بالانترنت");
    Future.delayed(Duration(seconds: 10), () => isShowNoInternetToast = false);
  }
}
