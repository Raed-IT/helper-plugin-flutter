import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/home/home_binding.dart';
import 'package:helper_plugin_example/app/pages/home/home_screen.dart';

class HomePage extends GetPage {
  HomePage()
      : super(
          name: "/home",
          page: () => HomeScreen(),
          binding: HomeBinding(),
        );
}
