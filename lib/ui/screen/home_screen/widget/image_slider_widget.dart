import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_images.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_strings.dart';
import 'package:demo_news_app/infrastructure/common/utills/route_constant.dart';
import 'package:demo_news_app/infrastructure/models/response/news_response_model.dart';
import 'package:demo_news_app/infrastructure/providers/home_page_provider/home_page_provider.dart';
import 'package:demo_news_app/infrastructure/providers/provider_registration.dart';
import 'package:demo_news_app/ui/common_widgets/text_widget.dart';
import 'package:demo_news_app/ui/screen/detail_screen/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageSlider extends StatefulWidget {
  final bool? enableTap;
  final HomePageProvider? provider;

  ImageSlider({Key? key, this.enableTap: true, this.provider}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    if(widget.provider!.allNewsList!.isNotEmpty){
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    allowImplicitScrolling: false,
                    dragStartBehavior: DragStartBehavior.down,
                    onPageChanged: (int page) {
                      context.read(homePageProvider).currentPage(page);
                    },
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: widget.provider!.controller,
                    children: widget.provider!.allNewsList!.map((item) => InkResponse(
                      onTap: () {
                        if (widget.enableTap!) {}
                      },
                      child: Stack(
                        children: [
                          buildImage(item!),
                          buildHeading(item),
                        ],
                      ),
                    )).toList(),
                  ),
                  buildPageIndicator()
                ],
              ),
            ),
            Divider(),
          ]);
    }else{
      return Container();
    }
  }

  Align buildPageIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 20,
        child: Center(
          child: Builder(builder: (context) {
            if (widget.provider!.allNewsList!.isEmpty || widget.provider!.allNewsList!.length == 1) {
              return Container();
            }

            return ValueListenableBuilder(
              valueListenable: widget.provider!.currentPageValue,
              builder: (BuildContext? context, int? value, Widget? child) {
                return SmoothPageIndicator(
                    controller: widget.provider!.controller,
                    // PageController
                    count: widget.provider!.allNewsList!.length,
                    effect: ScrollingDotsEffect(
                      activeDotColor: Color.fromRGBO(92, 92, 92, 1),
                      dotColor: Color.fromRGBO(213, 213, 213, 1),
                      dotHeight: 7,
                      activeDotScale: 1,
                      fixedCenter:
                          (widget.provider!.allNewsList!.length) > 7 && value! >= 3
                              ? true
                              : false,
                      strokeWidth: 0.001,
                      activeStrokeWidth: 0.001,
                      dotWidth: 7,
                      spacing: 5,
                      maxVisibleDots: (widget.provider!.allNewsList!.length) > 7
                          ? value! >= 3
                              ? 7
                              : 5
                          : 7,
                    ),
                    // your preferred effect
                    onDotClicked: (index) {});
              },
            );
          }),
        ),
      ),
    );
  }

  Widget buildImage(Articles? item) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: item!.urlToImage ?? AppStrings.defaultImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 15,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  image: AssetImage(AppImages.defaultErrorImage),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Align buildHeading(Articles? item) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteConstant.detailScreenRoute,
              arguments:
                  DetailScreenArgument(articles: item!, provider: widget.provider!));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextWidget(
                    text: item!.title!,
                    fontColor: AppColors.white,
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
                        child: item.author!.isNotEmpty
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      text: item.author ?? 'Random author',
                                      fontColor: AppColors.white,
                                      align: TextAlign.left,
                                      fontSize: 12,
                                      softWrap: false,
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
                          color: AppColors.white,
                          size: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextWidget(
                            text: random.nextInt(100).toString(),
                            fontColor: AppColors.white,
                            align: TextAlign.left,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.share,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
