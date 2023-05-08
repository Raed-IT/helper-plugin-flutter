import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../providers/pagination_provider.dart';

mixin PaginationMixin {
  String? nextPageUrl;
  RxBool isLoadMore = RxBool(false);
  Rx<bool> isLoad = RxBool(false);
  RxInt total = RxInt(0);
  bool isFirstPage = false;

  PaginationProvider paginationProvider = PaginationProvider();
  String? parameter;

  //Todo:: [setData] this function return data from request
  void setData(Map<String, dynamic>? data, bool isRefresh);

  Future<bool> getData(
      {required void Function(Map<String, dynamic>? data, bool isRefresh)
          setData,
      required String url,
      required bool isRefresh}) async {
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
        debugPrint(
            "print from helper -->> $url${parameter != null ? '?$parameter' : ''}");

        Response response = await paginationProvider.getData(
            url: "$url${parameter != null ? '?$parameter' : ''}");
        debugPrint(response.body);
        if (response.statusCode == 200) {
          setData(response.body, isRefresh);
          setPaginationData(response.body);
          isLoad.value = false;
          isFirstPage = false;
        } else if (response.statusCode == null) {
          await Future.delayed(const Duration(seconds: 3), () async {
            await getData(setData: setData, url: url, isRefresh: isRefresh);
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
          debugPrint(
              "print from helper -- load now ---- >> ${response.statusCode}");
          if (response.statusCode == 200) {
            setData(response.body, isRefresh);
            setPaginationData(response.body);
            isLoadMore.value = false;
          } else {
            await Future.delayed(const Duration(seconds: 3), () async {
              isLoadMore.value = false;
              await getData(
                  setData: setData, url: nextPageUrl ?? url, isRefresh: false);
            });
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "$e");
        }
      }
    }
    // return true is Last page data else whe have more data
    return nextPageUrl == null;
  }

  void setPaginationData(Map<String, dynamic> data) {
    data = data['data'];
    if (data.containsKey("pagination")) {
      nextPageUrl = data["pagination"]['next_page_url'];
      total.value = data["pagination"]['total'];
    }
  }
}
