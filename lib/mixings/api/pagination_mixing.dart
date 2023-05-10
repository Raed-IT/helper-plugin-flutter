import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/general_model.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';
import '../../providers/api_provider.dart';
 import '../../ui/lists/refresh_load_ui.dart';

// Generics
mixin PaginationMixin<T> {
  String? mainUrl;
  String? nextPageUrl;
  RxBool isLoadMore = RxBool(false);
  Rx<bool> isLoad = RxBool(false);
  RxInt total = RxInt(0);
  bool isFirstPage = false;
  ScrollController scrollController = ScrollController();
  ApiProvider paginationProvider = ApiProvider();
  String? parameter;
  RxList<T> data = RxList([]);

  List<T> getModelFromJsonUsing(Map<String, dynamic> json);

  //Todo:: [setData] this function return data from request
  void setData(Map<String, dynamic>? mapData, bool isRefresh) {
    if (mapData != null) {
      if (isRefresh) {
        data.clear();
        data.value = getModelFromJsonUsing(mapData);
      } else {
        //load data
        data.addAll(getModelFromJsonUsing(mapData));
      }
    }
  }

  set url(String url) {
    mainUrl = url;
  }

  Future<bool> getData({
    required bool isRefresh,
    bool isPrintResponse = false,
  }) async {
    if (mainUrl == null) {
      throw Exception(
          "[helper] : pleas assign url in onInit function in controller (^._.^)  ");
    }
    if (isRefresh) {
      //break loop get data from api page 1, 2 ,3, 4 , ... 1, 2, 3,
      nextPageUrl = null;
      isFirstPage = true;
      isLoad.value = false;
    }

    //get fresh data now
    if (nextPageUrl == null && !isLoad.value && isFirstPage) {
      isLoad.value = true;
      try {
        Response response = await paginationProvider.getData(
            url: "$mainUrl${parameter != null ? '?$parameter' : ''}");
        if (isPrintResponse) {
          printHelper("${response.body}");
        }
        if (response.statusCode == 200) {
          setData(response.body, isRefresh);
          setPaginationData(response.body);
          isLoad.value = false;
          isFirstPage = false;
        } else if (response.statusCode == null) {
          await Future.delayed(const Duration(seconds: 3), () async {
            await getData(isRefresh: isRefresh);
          });
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
              url: '${nextPageUrl!}${parameter != null ? '&$parameter' : ''}');
          printHelper("${response.statusCode}");
          if (response.statusCode == 200) {
            setData(response.body, isRefresh);
            setPaginationData(response.body);
            isLoadMore.value = false;
          } else {
            await Future.delayed(const Duration(seconds: 3), () async {
              isLoadMore.value = false;
              await getData(isRefresh: false);
            });
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "$e");
        }
      }
    }
    // return true is Last page data else we have more data
    return nextPageUrl == null;
  }

  void setPaginationData(Map<String, dynamic> data) {
    data = data['data'];
    if (data.containsKey("pagination")) {
      nextPageUrl = data["pagination"]['next_page_url'];
      total.value = data["pagination"]['total'];
    }
  }

  Widget buildScreen({
    required List<Widget> widgets,
    required Widget appBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool isClosable = false,
    Future<void> Function()? onRefresh,
    Future<bool> Function()? loadModer,
  }) {
    return RefreshLoadComponent(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      isClosable: isClosable,
      appBar: appBar,
      onRefresh: () {
        return getData(
          isRefresh: true,
        );
      },
      isLoadMore: isLoadMore,
      loadModer: () {
        //if nextPageUrl equal null the page is last page return false for show no more data widget
        if (nextPageUrl != null) {
          return getData(
            isRefresh: false,
          );
        }
        return Future.value(true);
      },
      widgets: widgets,
      scrollController: scrollController,
    );
  }
}
