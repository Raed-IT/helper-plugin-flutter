import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';
import '../../providers/api_provider.dart';
import '../../ui/lists/refresh_load_ui.dart';
import '../../utilitis/internet_connection_checker.dart';

// Generics
mixin PaginationMixin<T> {
  String? mainPaginationUrl;
  String? nextPageUrl;
  RxBool isConnectionError = RxBool(false);
  RxBool isLoadMore = RxBool(false);
  Rx<bool> isLoadPagination = RxBool(false);

  // RxInt total = RxInt(0);
  bool isFirstPage = false;
  ScrollController scrollController = ScrollController();
  ApiProvider paginationProvider = ApiProvider();
  String? paginationParameter;
  RxList<T> paginationData = RxList([]);

  List<T> getModelFromPaginationJsonUsing(Map<String, dynamic> json);

  String? getNextUrlForPaginationUsing(Map<String, dynamic> data) => "not used";

/*

  Usage below .....


  @override
  Map<String, dynamic> getNextUrlForPaginationUsing(Map<String, dynamic> data) {
    return "${data['data']['pagination']['next_page_url']}";
  }

*/
  void setData(Map<String, dynamic>? mapData, bool isRefresh) {
    if (mapData != null) {
      if (isRefresh) {
        paginationData.clear();
        paginationData.value = getModelFromPaginationJsonUsing(mapData);
      } else {
        //load data
        paginationData.addAll(getModelFromPaginationJsonUsing(mapData));
      }
    }
  }

  set url(String url) {
    mainPaginationUrl = url;
  }

  Future<bool> getPaginationData(
      {required bool isRefresh,
      bool isPrintResponse = false,
      int? countTying}) async {
    if (await checkInternet()) {
      if (mainPaginationUrl == null) {
        String message =
            "[helper] : pleas assign url in onInit function in controller (^._.^)  ";
        printHelper(message);
        throw Exception(message);
      }
      if (isRefresh) {
        //break loop get data from api page 1, 2 ,3, 4 , ... 1, 2, 3,
        nextPageUrl = null;
        isFirstPage = true;
        isLoadPagination.value = false;
      }

      //get fresh data now
      if (nextPageUrl == null && !isLoadPagination.value && isFirstPage) {
        isLoadPagination.value = true;
        try {
          Response response = await paginationProvider.getData(
              url:
                  "$mainPaginationUrl${paginationParameter != null ? '?$paginationParameter' : ''}");
          if (isPrintResponse) {
            printHelper("${response.body}");
          }
          if (response.statusCode == 200) {
            setData(response.body, isRefresh);
            setPaginationData(response.body);
            isLoadPagination.value = false;
            isFirstPage = false;
          } else if (response.statusCode == null) {
            await Future.delayed(const Duration(seconds: 3), () async {
              if (countTying != null && countTying == 4) {
                Fluttertoast.showToast(
                    msg: "الرجاء التاكد من الاتصال بالانترنت  ");
                isLoadPagination.value = false;
              } else {
                getPaginationData(
                    isRefresh: isRefresh,
                    isPrintResponse: isPrintResponse,
                    countTying: countTying == null ? 1 : (countTying + 1));
              }
            });
          } else {
            isLoadPagination.value = false;
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "$e");
        }
      } else {
        //  load data now
        if (!isLoadMore.value && nextPageUrl != null) {
          isLoadMore.value = true;
          try {
            Response response = await paginationProvider.getData(
                url:
                    '${nextPageUrl!}${paginationParameter != null ? '&$paginationParameter' : ''}');
            if (response.statusCode == 200) {
              isConnectionError.value = false;
              setData(response.body, isRefresh);
              setPaginationData(response.body);
              isLoadMore.value = false;
            } else {
              await Future.delayed(const Duration(seconds: 3), () async {
                isLoadMore.value = false;
                if (countTying != null && countTying == 2) {
                  isConnectionError.value = true;
                  isLoadMore.value = true;
                  Fluttertoast.showToast(
                      msg: "الرجاء التاكد من الاتصال بالانترنت  ");
                } else {
                  getPaginationData(
                      isRefresh: false,
                      isPrintResponse: isPrintResponse,
                      countTying: countTying == null ? 1 : (countTying + 1));
                }
              });
            }
          } catch (e) {
            Fluttertoast.showToast(msg: "$e");
          }
        }
      }
      // return true is Last page data else we have more data
      // printHelper("countTrying=> $countTying");
    } else {
      Fluttertoast.showToast(msg: "لايوجد اتصال بالانترنت ");
    }
    return nextPageUrl == null;
  }

  void setPaginationData(Map<String, dynamic> data) {
    String? urlDAta = getNextUrlForPaginationUsing(data);

    /// [getNextUrlForPaginationUsing] return null if current page is last page else return next page url  or not used

    if (urlDAta != "not used") {
      printHelper(urlDAta);
      nextPageUrl = urlDAta;
    } else {
      data = data['data'];
      if (data.containsKey("pagination")) {
        nextPageUrl = data["pagination"]['next_page_url'];
        // total.value = data["pagination"]['total'];
      }
    }
  }

  Widget buildScreen({
    required List<Widget> widgets,
    required Widget appBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    bool isClosable = false,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    Future<void> Function()? onRefresh,
    Future<bool> Function()? onLoadModer,
  }) {
    return RefreshLoadComponent(
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      isClosable: isClosable,
      appBar: appBar,
      onRefresh: () {
        if (onRefresh != null) {
          onRefresh();
        }
        return getPaginationData(
          isRefresh: true,
        );
      },
      isLoadMore: isLoadMore,
      loadModer: (isTap) {
        //if nextPageUrl equal null the page is last page return false for show no more data widget
        if (nextPageUrl != null) {
          if (onLoadModer != null) {
            onLoadModer();
          }
          if (isTap) {
            isLoadMore.value = false;
            isConnectionError.value = false;
            return getPaginationData(
              countTying: null,
              isRefresh: false,
            );
          } else {
            return getPaginationData(
              isRefresh: false,
            );
          }
        }
        return Future.value(true);
      },
      widgets: widgets,
      scrollController: scrollController,
      isConnectionError: isConnectionError,
    );
  }
}
