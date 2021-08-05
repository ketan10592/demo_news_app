import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_images.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_strings.dart';
import 'package:demo_news_app/infrastructure/common/utills/date_times_util.dart';
import 'package:demo_news_app/infrastructure/common/utills/route_constant.dart';
import 'package:demo_news_app/infrastructure/models/response/news_response_model.dart';
import 'package:demo_news_app/infrastructure/providers/home_page_provider/home_page_provider.dart';
import 'package:demo_news_app/infrastructure/providers/provider_registration.dart';
import 'package:demo_news_app/ui/common_widgets/cupertino_dialog.dart';
import 'package:demo_news_app/ui/common_widgets/text_widget.dart';
import 'package:demo_news_app/ui/screen/detail_screen/detail_screen.dart';
import 'package:demo_news_app/ui/screen/home_screen/widget/image_slider_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  HomePageProvider? provider;
  Random random = new Random();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callInit();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      //callInit();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        bool? isLastPage = provider!.reachedLastPage;
        if (!isLastPage!) {
          EasyDebounce.debounce(
              'debounce1',
              Duration(milliseconds: 500),
              () => context
                  .read(homePageProvider)
                  .callGetNewsApi(context: context, showLoading: false));
        } else {
          print('reach last page');
        }
      }
    });
  }

  callInit() async {
    var _isConnected =
        await context.read(homePageProvider).checkInternetConnection();
    if (!_isConnected) {
      await showNoConnection();
      return;
    }
    context
        .read(homePageProvider)
        .callGetNewsApi(context: context, showLoading: true);
    context.read(homePageProvider).callGetAllNewsApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext? context, watch, Widget? child) {
        provider = watch(homePageProvider);
        return Scaffold(
          appBar: AppBar(
            title: TextWidget(
              text: AppStrings.home,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontColor: Theme.of(context!).accentColor,
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                    child:
                        AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                            ? Image(
                                image: AssetImage(AppImages.dayMode),
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              )
                            : Image(
                                image: AssetImage(AppImages.nightMode),
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                    onTap: () {
                      AdaptiveTheme.of(context).toggleThemeMode();
                    }),
              )
            ],
          ),
          body: Container(
            child: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {

    if(provider!.isMainLoading!){
      return Center(
        child: CupertinoActivityIndicator(radius: 15,),
      );
    }
    return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: TextWidget(
                  text: AppStrings.topHeadlines,
                  fontSize: 18,
                  align: TextAlign.left,
                  fontWeight: FontWeight.bold,
                  fontColor: Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.longestSide / 3,
              child: ImageSlider(
                provider: provider!,
                enableTap: true,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 5),
                child: TextWidget(
                  text: AppStrings.recentNews,
                  fontSize: 18,
                  align: TextAlign.left,
                  fontWeight: FontWeight.bold,
                  fontColor: Theme.of(context).accentColor,
                ),
              ),
            ),
            provider!.topNewsList.isNotEmpty ? _buildList() : noContentWidget()
          ],
        ));
  }

  Container noContentWidget() {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      child: Center(
        child: TextWidget(
          text: AppStrings.noContentFound,
          fontSize: 16,
          align: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
      child: ListView.builder(
        itemCount: provider!.topNewsList.length + 1,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == provider!.topNewsList.length) {
            if (provider!.reachedLastPage!) {
              return Container();
            } else {
              return Container(
                height: 40,
                child: Center(
                  child: CupertinoActivityIndicator(radius: 15.0),
                ),
              );
            }
          }
          var data = provider!.topNewsList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: listItemWidget(context, data),
          );
        },
      ),
    );
  }

  Widget listItemWidget(BuildContext context, Articles? data) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteConstant.detailScreenRoute,
            arguments:
                DetailScreenArgument(articles: data!, provider: provider!));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Container(
          height: 120,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CachedNetworkImage(
                  imageUrl: data?.urlToImage ?? AppStrings.defaultImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.defaultErrorImage),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.grayD2),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              child: TextWidget(
                                text: data?.source?.name ?? 'Name',
                                fontColor: AppColors.black,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextWidget(
                            text:
                                '${DateTimeUtils().getTimeAgo(data!.publishedAt!)} ago',
                            fontSize: 12,
                            fontColor: AppColors.grayC2,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextWidget(
                          text: data.title ?? AppStrings.defaultTitle,
                          fontColor: Theme.of(context).accentColor,
                          fontSize: 16,
                          align: TextAlign.left,
                          softWrap: true,
                          maxLine: 2,
                          textHeight: 1.3,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: data.author != null && data.author != ''
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: AppColors.grayC2,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Expanded(
                                          child: TextWidget(
                                            text:
                                                data.author ?? 'Random author',
                                            fontColor: AppColors.grayC2,
                                            align: TextAlign.left,
                                            fontSize: 12,
                                            maxLine: 1,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.comment,
                                color: AppColors.grayD2,
                                size: 16,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextWidget(
                                  text: random.nextInt(100).toString(),
                                  fontColor: AppColors.grayC2,
                                  align: TextAlign.left,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.share,
                                color: AppColors.grayC2,
                                size: 16,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future showNoConnection() async {
    await showCupertinoAlertDialogWithTwoButtonsMethod(
      context,
      title: AppStrings.noInternet,
      body: AppStrings.checkInterNet,
      firstButtonText: AppStrings.retry,
      callbackForFirstButton: () {
        Navigator.of(context, rootNavigator: true).pop();
        callInit();
      },
    );
  }
}
