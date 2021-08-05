import 'dart:convert';
import 'dart:io';

import 'package:demo_news_app/infrastructure/common/utills/api_constant.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_strings.dart';
import 'package:demo_news_app/infrastructure/models/response/error_response_model.dart';
import 'package:demo_news_app/infrastructure/models/response/news_response_model.dart';
import 'package:demo_news_app/ui/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenRepository{
  resultInApi(var value, var isError) {
    Map<String, dynamic> map = {"value": value, "isError": isError};
    return map;
  }

  Future<Map> callGetTopHeadLinesApi({BuildContext? context, int? pageNumber}) async {
    try {
      http.Response result;
      var url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.topHeadLines}?country=us&pageSize=10&page=$pageNumber');
      var header = ApiConstant().apiHeader;
      header['X-Api-Key'] = 'd32f4f28a48a448ca7bad4aa9b1767a6';
      result = await http.get(url, headers: header);
      print('Get news result : ${result.body}');
      if (result.statusCode == 200) {
        Map data = jsonDecode(result.body);
        NewsResponseModel responseModel = NewsResponseModel.fromJson(data);
        return resultInApi(responseModel, false);
      } else {
        Map data = jsonDecode(result.body);
        ErrorResponseModel responseModel = ErrorResponseModel.fromJson(data);
        return resultInApi(responseModel, true);
      }
    } on SocketException {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: TextWidget(
          text: AppStrings.noInterNetConnection,fontColor: AppColors.white,
        ),
        duration: Duration(seconds: 5),
      ));
      return resultInApi(AppStrings.noInterNetConnection, true);
    } catch (e) {
      print('Exception in callGetTopHeadLineApi : $e');
      return resultInApi(e.toString(), true);
    }
  }

  Future<Map> callGetAllNewsApi({BuildContext? context}) async {
    try {
      http.Response result;
      var url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.everything}?domains=techcrunch.com,thenextweb.com&pageSize=10&page=5');
      var header = ApiConstant().apiHeader;
      header['X-Api-Key'] = 'd32f4f28a48a448ca7bad4aa9b1767a6';
      result = await http.get(url, headers: header);
      print('Get news result : ${result.body}');
      if (result.statusCode == 200) {
        Map data = jsonDecode(result.body);
        NewsResponseModel responseModel = NewsResponseModel.fromJson(data);
        return resultInApi(responseModel, false);
      } else {
        Map data = jsonDecode(result.body);
        ErrorResponseModel responseModel = ErrorResponseModel.fromJson(data);
        return resultInApi(responseModel, true);
      }
    } on SocketException {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: TextWidget(
          text: AppStrings.noInterNetConnection,fontColor: AppColors.white,
        ),
        duration: Duration(seconds: 5),
      ));
      return resultInApi(AppStrings.noInterNetConnection, true);
    } catch (e) {
      print('Exception in callGetAllNewsApi : $e');
      return resultInApi(e.toString(), true);
    }
  }
}