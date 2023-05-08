import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RefreshLoadComponent extends StatefulWidget {
  ScrollController scrollController;
  List<Widget> widgets;
  Widget appBar;
  Future<void> Function()? onRefresh;
  Future<bool> Function()? loadModer;
  RxBool? isLoadMore;

  RefreshLoadComponent({
    super.key,
    required this.appBar,
    required this.widgets,
    this.onRefresh,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollAppBehavior(),
        child: RefreshIndicator(
          edgeOffset: widget.onRefresh == null ? -1000 : 20.h,
          onRefresh: widget.onRefresh ??
              () {
                return Future.value(false);
              },
          child: CustomScrollView(
            // physics: BouncingScrollPhysics(),
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
                          child: Container(
                            margin: EdgeInsets.only(bottom: 40.h, top: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('يتم تحميل البيانات ',
                                    style: TextStyle(color: Colors.black45)),
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
        bool state = await widget.loadModer!();
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
