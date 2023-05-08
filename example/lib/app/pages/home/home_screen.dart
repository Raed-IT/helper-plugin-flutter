import 'package:get/get.dart';
import 'package:helper_plugin_example/app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "helper plugin ",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                Get.toNamed("pick_image");
              },
              child: Text("Image picker test "),
            )
          ],
        ),
      ),
    );
  }
}
