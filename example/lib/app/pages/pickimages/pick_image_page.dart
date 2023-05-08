import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/pickimages/pick_image_binding.dart';

import 'package:helper_plugin_example/app/pages/pickimages/pick_image_screen.dart';

class PickImagePage extends GetPage {
  PickImagePage()
      : super(
            name: "/pick_image",
            page: () => PickImageScreen(),
            binding: PickImageBinding());
}
