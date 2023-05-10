

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
```

## Features
`Under development for more Features`




\
`images mixin `
- selecet multi images or singile image and pressure  it eslay
- update any ui for privew selected image or main selected widget

`api mixin `
- eslay implement pagination or load more ui or `API` handling


## Usage/Pagination
`controlle : `
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
          () => (controller.isLoad.value)
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

| val name             | desription                                                                |
| ----------------- | ------------------------------------------------------------------ |
| isLoade |  true when call api else false  |
| data  |   List of  data avilabel from same model screen ex: NotificationModel |
 

