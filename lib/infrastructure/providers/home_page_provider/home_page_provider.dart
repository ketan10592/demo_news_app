import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_strings.dart';
import 'package:demo_news_app/infrastructure/models/response/error_response_model.dart';
import 'package:demo_news_app/infrastructure/models/response/news_response_model.dart';
import 'package:demo_news_app/infrastructure/network_service/repository/home_page_screen_repository/home_screen_repository.dart';
import 'package:demo_news_app/ui/common_widgets/cupertino_loding_dialog.dart';
import 'package:demo_news_app/ui/common_widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageProvider with ChangeNotifier {
  final ref;

  HomePageProvider(this.ref);

  HomeScreenRepository _repository = HomeScreenRepository();

  int? pageNumber = 1;
  double? fontSize = 0.0;

  bool? _isMainLoading = true;
  bool? get isMainLoading => _isMainLoading;

  List<Articles?> _topNewsList = [];

  List<Articles?> get topNewsList => _topNewsList;

  List<Articles?>? _allNewsList = [];
  List<Articles?>? get allNewsList => _allNewsList;

  bool? _reachedLastPage = false;

  bool? get reachedLastPage => _reachedLastPage;

  final controller = PageController(viewportFraction: 1);
  ValueNotifier<int> currentPageValue = ValueNotifier<int>(0);
  ValueNotifier<double> customFontSizeValue = ValueNotifier<double>(0.0);


  void setLoading(bool? value){
    _isMainLoading = value;
    notifyListeners();
  }

  void currentPage(int page) {
    currentPageValue.value = page;
  }

  void increaseFontSize() {
    if (fontSize! < 6) {
      fontSize = fontSize! + 1;
      customFontSizeValue.value = fontSize!;
    }
  }

  void decreaseFontSize() {
    if (fontSize! > 0) {
      fontSize = fontSize! - 1;
      customFontSizeValue.value = fontSize!;
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future callGetNewsApi(
      {@required BuildContext? context, bool? showLoading}) async {
    if (showLoading!) {
      setLoading(true);
    }
    try {
      Map result = await _repository.callGetTopHeadLinesApi(
          context: context!, pageNumber: pageNumber!);
      if (!result["isError"]) {
        NewsResponseModel? response = result["value"];
        if (response!.articles!.isNotEmpty) {
          if (response.status == 'ok') {
            response.articles!.forEach((element) {
              _topNewsList.add(element);
            });
            if (_topNewsList.length == response.totalResults) {
              _reachedLastPage = true;
            } else {
              pageNumber = pageNumber! + 1;
            }
          }
        }
      } else {
        if (result['value'] is String) {
          print('${result['value'] ?? AppStrings.somethingWentWrong}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextWidget(
            text: '${result['value'] ?? AppStrings.somethingWentWrong}',
            fontColor: AppColors.white,
          )));
        } else {
          ErrorResponseModel error = result['value'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextWidget(
            text: '${error.message}',
            fontColor: AppColors.white,
          )));
          print('${error.message}');
        }
      }
    } catch (e) {
      print('get news api exception : $e');
    }
    if (showLoading) {
      setLoading(false);
    }else{
      notifyListeners();
    }
  }

  Future callGetAllNewsApi({@required BuildContext? context}) async {
    try {
      Map result = await _repository.callGetAllNewsApi(context: context!);
      if (!result["isError"]) {
        NewsResponseModel response = result["value"];
        if (response is NewsResponseModel &&
            response.articles != null &&
            response.articles!.isNotEmpty) {
          if (response.status == 'ok') {
            _allNewsList = response.articles;
          }
        }
      } else {
        if (result['value'] is String) {
          print('${result['value'] ?? AppStrings.somethingWentWrong}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextWidget(
            text: '${result['value'] ?? AppStrings.somethingWentWrong}',
            fontColor: AppColors.white,
          )));
        } else {
          ErrorResponseModel error = result['value'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextWidget(
            text: '${error.message ?? AppStrings.somethingWentWrong}',
            fontColor: AppColors.white,
          )));
         print('${error.message ?? AppStrings.somethingWentWrong}');
        }
      }
    } catch (e) {
      print('get all news api exception : $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _reachedLastPage = false;
    pageNumber = 1;
    _topNewsList = [];
    currentPageValue.dispose();
    customFontSizeValue.dispose();
    super.dispose();
  }
}
