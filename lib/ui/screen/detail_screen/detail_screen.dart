import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_images.dart';
import 'package:demo_news_app/infrastructure/common/utills/app_strings.dart';
import 'package:demo_news_app/infrastructure/common/utills/date_times_util.dart';
import 'package:demo_news_app/infrastructure/models/response/news_response_model.dart';
import 'package:demo_news_app/infrastructure/providers/home_page_provider/home_page_provider.dart';
import 'package:demo_news_app/infrastructure/providers/provider_registration.dart';
import 'package:demo_news_app/ui/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends StatefulWidget {
  final DetailScreenArgument? data;

  const DetailScreen({Key? key, this.data}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImageWidget(context),
            buildHeadingWidget(),
            detailWidget(),
            buildWebView(),
            buildSampleText(),
          ],
        ),
      ),
    );
  }

  Stack buildImageWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .longestSide / 3,
          child: CachedNetworkImage(
            imageUrl: widget.data!.articles.urlToImage ??
                AppStrings.defaultImage,
            imageBuilder: (context, imageProvider) =>
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) =>
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.defaultErrorImage),
                        fit: BoxFit.cover),
                  ),
                ),
          ),
        ),
        Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ))),
        Positioned(
            top: 40,
            right: 15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () {
                      AdaptiveTheme.of(context).toggleThemeMode();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: AdaptiveTheme
                              .of(context)
                              .mode ==
                              AdaptiveThemeMode.dark ? null : AppColors.white
                              .withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: AdaptiveTheme
                          .of(context)
                          .mode ==
                          AdaptiveThemeMode.dark
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
                    )),
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: () {
                      context.read(homePageProvider).increaseFontSize();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.zoom_in_outlined,
                          color: Colors.white,
                          size: 24,
                        )
                    )),
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: () {
                      context.read(homePageProvider).decreaseFontSize();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.zoom_out_outlined,
                          color: Colors.white,
                          size: 24,
                        )
                    )),
              ],
            )),
      ],
    );
  }

  Widget buildHeadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
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
                    color: AppColors.colorRama),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: textWidget(
                    text: widget.data!.articles.source!.name ?? 'CNBC',
                    fontColor: AppColors.white,
                    fontSize: 11,
                    key: Key('Source Name')
                  ),
                ),
              ),
              textWidget(
                text:
                '${DateTimeUtils().getTimeAgo(
                    widget.data!.articles.publishedAt!)} ago',
                fontSize: 12,
                fontColor: AppColors.gray,
                key: Key('time ago')
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: textWidget(
              text: widget.data!.articles.title ?? AppStrings.defaultTitle,
              fontColor: Theme
                  .of(context)
                  .accentColor,
              fontSize: 16,
              align: TextAlign.left,
              softWrap: true,
              maxLine: 10,
              textHeight: 1.3,
                key: Key('title')
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: widget.data!.articles.author != null &&
                      widget.data!.articles.author != ''
                      ? Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: AppColors.gray,
                        size: 16,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: textWidget(
                          text:
                          widget.data!.articles.author ?? 'Random author',
                          fontColor: AppColors.gray,
                          align: TextAlign.left,
                          fontSize: 12,
                          maxLine: 1,
                            key: Key('Author Name')
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
                    color: AppColors.gray,
                    size: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: textWidget(
                      text: random.nextInt(100).toString(),
                      fontColor: AppColors.gray,
                      align: TextAlign.left,
                      fontSize: 12,
                        key: Key('comment')
                    ),
                  ),
                  Icon(
                    Icons.share,
                    color: AppColors.gray,
                    size: 16,
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(),
          )
        ],
      ),
    );
  }

  Widget detailWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: textWidget(
          text: widget.data!.articles.description ?? '',
          align: TextAlign.left,
          softWrap: true,
          maxLine: 50,
          key: Key('description'),
          fontColor: Theme
              .of(context)
              .accentColor,
          fontSize: 14),
    );
  }

  Widget buildWebView() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: GestureDetector(
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                content: webViewDialog(),
                insetPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              );
            },
          );
        },
        child: Container(
          child: textWidget(
              text:
              'Read more : ${widget.data!.articles.url ??
                  AppStrings.defaultWebUrl}',
              fontColor: AppColors.blue,
              fontSize: 14,
              maxLine: 10,
              softWrap: true,
              key: Key('read more'),
              align: TextAlign.left),
        ),
      ),
    );
  }

  Widget webViewDialog() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height - 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    widget.data!.articles.url ?? AppStrings.defaultWebUrl)),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    verticalScrollBarEnabled: true,
                    disableVerticalScroll: false),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.black28),
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSampleText() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: textWidget(
        text: AppStrings.sampleText1,
        align: TextAlign.left,
        softWrap: true,
        maxLine: 100,
        fontSize: 14,
        key: Key('sample text'),
        fontColor: Theme
            .of(context)
            .accentColor,
      ),
    );
  }

  Widget textWidget({String? text,
    double? fontSize,
    Color? fontColor,
    TextAlign? align,
    bool? softWrap,
    int? maxLine,
    double? textHeight, Key? key}) {
    return ValueListenableBuilder(
      valueListenable: widget.data!.provider.customFontSizeValue,
      builder: (BuildContext? context, double? value, Widget? child) {
        return TextWidget(
          key: key,
          text: text,
          fontColor: fontColor,
          fontSize: fontSize! + value!,
          align: align ?? TextAlign.left,
          softWrap: softWrap,
          maxLine: maxLine,
          textHeight: textHeight,
        );
      },
    );
  }
}

class DetailScreenArgument {
  final Articles articles;
  final HomePageProvider provider;

  DetailScreenArgument({required this.articles, required this.provider});
}
