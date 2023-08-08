import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';

import '../../utilitis/constats.dart';

// ignore: must_be_immutable
class RefreshLoadComponent extends StatefulWidget {
  ScrollController scrollController;
  List<Widget> widgets;
  Widget appBar;
  Widget? floatingActionButton;
  Future<void> Function()? onRefresh;
  Future<bool> Function(bool isTap)? loadModer;
  RxBool? isLoadMore;
  RxBool isConnectionError = RxBool(false);
  bool isClosable;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  Widget? bottomNavigationBar;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;

  RefreshLoadComponent({
    super.key,
    required this.isClosable,
    this.floatingActionButtonAnimator,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    required this.appBar,
    required this.widgets,
    this.onRefresh,
    required this.isConnectionError,
    this.isLoadMore,
    this.loadModer,
    required this.scrollController,
  }) : assert(loadModer != null ? isLoadMore?.value != null : true,
            "if using load more function provide this component <<isLoadMore>> variable 😊");

  @override
  State<RefreshLoadComponent> createState() => _RefreshLoadComponentState();
}

class _RefreshLoadComponentState extends State<RefreshLoadComponent> {
  bool _isFinshLoadMore = false;
  var ctime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      bottomNavigationBar: widget.bottomNavigationBar,
      drawerEnableOpenDragGesture:
          ConstantHelperMadaFlutter.drawerWidget == null,
      drawer: ConstantHelperMadaFlutter.drawerWidget,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: WillPopScope(
        onWillPop: () {
          if (widget.isClosable) {
            DateTime now = DateTime.now();
            if (ctime == null || now.difference(ctime) > Duration(seconds: 1)) {
              //add duration of press gap
              ctime = now;
              Fluttertoast.showToast(
                  msg: "اضغط مره اخرى للخروج",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: ConstantHelperMadaFlutter.toastFontSize ?? 16.0.sp);
              return Future.value(false);
            }
            SystemNavigator.pop();
            return Future.value(true);
          } else {
            return Future.value(true);
          }
        },
        child: ScrollConfiguration(
          behavior: ScrollAppBehavior(),
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            edgeOffset: widget.onRefresh == null ? -1000 : 20.h,
            onRefresh: widget.onRefresh ??
                () {
                  return Future.value(false);
                },
            child: CustomScrollView(
              physics: ConstantHelperMadaFlutter.scrollPhysics,
              controller: widget.scrollController,
              slivers: [
                widget.appBar,
                ...widget.widgets,
                if (_isFinshLoadMore)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40.h, top: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لا يوجد مزيد من البيانات  ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          const Icon(
                            Icons.next_plan_outlined,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                  ),
                if (widget.loadModer != null)
                  if (widget.isLoadMore!.value)
                    Obx(
                      () {
                        if (widget.isLoadMore!.value) {
                          return SliverToBoxAdapter(
                            child: (widget.isConnectionError.value)
                                ? GestureDetector(
                                    onTap: () {
                                      widget.loadModer!(true);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 40.h, top: 10.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'خطاء في الاتصال  ',
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child: const Icon(Icons.refresh),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 40.h, top: 10.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('يتم تحميل البيانات ',
                                            style: TextStyle(
                                                color: Colors.black45)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                          width: 20.h,
                                          child: CircularProgressIndicator(
                                            color: Colors.black45,
                                            strokeWidth: 1.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          );
                        } else {
                          return SliverToBoxAdapter();
                        }
                      },
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(handelScrollController);
  }

  void handelScrollController() async {
    if (widget.scrollController.position.extentAfter < 300.h) {
      if (widget.loadModer != null) {
        bool state = await widget.loadModer!(false);
        if (mounted) {
          setState(() {
            _isFinshLoadMore = state;
          });
        }
      }
    }
  }
}

class ScrollAppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
