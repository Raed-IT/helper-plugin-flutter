# Helper Plugin for flutter

this plugin used wiht GETX pakage .. Developed by  [@Raed_IT](https://www.github.com/Raed-IT)

## Installation

open `pubspec.yaml` file and past below code

```bash
dependencies:
.
.
.

helper_plugin:
    git:
      url: https://github.com/Raed-IT/helper-plugin-flutter.git
      ref: <ref last commit for get last version >
```

open `android/app/build.grael` and Make sure enable multiDex

```dart
defaultConfig {

multiDexEnabled true

}
```

## listing to app token

Open the controller you are storing in Token as `RxnString`

```dart
class MainController extends GetxController {

  RxnString token = RxnString();

  @override
  void onInit() {
    //provide token to helper package any time user login package detected token 
    token.listen((value) {
      ConstantHelperMadaFlutter.token = token.value;
    });
    super.onInit();
  }
}
```

## Features

`Under development for more Features`

\
`images mixin `

- selecet multi images or singile image and pressure it eslay
- update any ui for privew selected image or main selected widget

`api mixin `

- eslay implement pagination or load more ui or `API` handling

## Usage/Pagination

`controller : `

```dart
import 'package:helper_plugin/helper.dart';

class NotificationController extends GetxController
    with PaginationMixin<NotificationModel> {

  @override
  void onInit() {
    super.onInit();
    //set the main url 
    url = GlobalApiRouts.NOTIFICATION;

    // call get data method from PaginationMixin
    getData(
      isRefresh: true,
    );
  }

  // return data in this funtion for specialty api data keys 
  @override
  List<NotificationModel> getModelFromJsonUsing(Map<String, dynamic> json) {
    List<NotificationModel> notifications = [];
    for (var item in json['data']['notifications']) {
      notifications.add(NotificationModel.fromJson(item));
    }
    return notifications;
  }

}
```

`Screen (UI) :`

```dart
import 'package:helper_plugin/helper.dart';


class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({Key? key}) : super(key: key);

// data currently Available  in data List 'same Model Screen '
// loadData  integrator Available 'isLoad'

  @override
  Widget build(BuildContext context) {
    return controller.buildScreen(
      appBar: SliverAppBar(),
      widgets: [
        Obx(
              () =>
          (controller.isLoad.value)
              ? ListProgressNotification()
              : (controller.data.isNotEmpty)
              ? AnimationSliverList(
            length: controller.data.length,
            builder: (context, index, animation) {
              return buildCard(notification: controller.data[index]);
            },
          )
              : NoDataSliverComponent(
            onTap: () => controller.getData(isRefresh: true),
          ),
        ),
      ],
    );
  }
}

```

## pagination mixin

| val name | description                                                          |
|----------|----------------------------------------------------------------------|
| isLoad   | true when call api else false                                        |
| data     | List of  data available from same model screen ex: NotificationModel |

## image  picker mixin

| val name      | description                                                                  |
|---------------|------------------------------------------------------------------------------|
| image         | picked image file                                                            |
| images        | List of Picked images files                                                  |
| imageCount    | to set count images for picker in multi images usage in oninit in controller |
| isEmptyImages | get if images List is Empty                                                  |
| isEmptyImage  | get if image is Empty                                                        |
| isEmptyImage  | get if image is Empty                                                        |

| function name           | description                                                                                               |
|-------------------------|-----------------------------------------------------------------------------------------------------------|
| getImage                | return  single piked image as MultipartFile                                                               |
| getImages               | return  List piked images as List of MultipartFile                                                        |
| buildPickerImageWidget  | build selected image ui if  image file is empty and preview image if image file not empty                 |
| buildPickerImagesWidget | build selected images ui if List  images files is empty and preview images if List images files not empty |

## Usage/imagePickerMixin

`Screen (UI) :`

```dart

class PickImageScreen extends GetView<PickImageController> {
  const PickImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("pick image example "),
      ),

      body: Column(
          children: [
            //single image picker 
            controller.buildPickerImageWidget(),


            //  multi images picker 
            controller.buildPickerImagesWidget()
          ]
      ),
    );
  }
}

```

`Controller `

```dart
import 'package:helper_plugin/helper.dart';

class PickImageController extends GetxController with ImagePickerMixin {
  @override
  void onInit() {
    imageCount = 5;
    super.onInit();
  }

  Future<void> sendRequest() async {
    // if use multi images picker use get imageS
    await getImages();

    //  if use single image picker use getImage ();
    await getImage();


    FormData data = FormData.fromMap({
      // data her .......
    });
    data.files.addAll(await getImages());
  }
}

```
