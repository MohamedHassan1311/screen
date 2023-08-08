import 'dart:async';

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:code_scan_listener/code_scan_listener.dart';
import 'package:flutter/services.dart';

import 'package:live/app/core/utils/dimensions.dart';
import 'package:live/data/api/end_points.dart';

import 'package:flutter/material.dart';
import 'package:live/features/dashBoard/provider/SpeakProvider.dart';
import 'package:live/features/dashBoard/provider/files_provider.dart';
import 'package:live/features/dashBoard/widget/side_bar_widget.dart';
import 'package:live/features/dashBoard/widget/vedioPlayer.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../../app/core/utils/color_resources.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/core/utils/images.dart';

import '../../data/network/netwok_info.dart';
import '../../data/signalR/signalr_client.dart';
import '../auth/select_branch_screen/provider/auth_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({this.index, Key? key}) : super(key: key);
  final int? index;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Timer? vedioTimer;
  Timer? photoTimer;
  late bool visible = true;
  TextEditingController textEditingController = TextEditingController();
  FocusNode? focusNode = FocusNode();
  CarouselController buttonCarouselController = CarouselController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      SignalrClient().startConnection();
      Provider.of<MediaProvider>(context, listen: false).getFilesByScreenID();
      Provider.of<AuthProvider>(context, listen: false).getTentStatusTimer();
    });
    NetworkInfo.checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return Scaffold(
      key: _key,
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(
        child: SideBarWidget(),
      ),
      body: VisibilityDetector(
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        key: const Key('visible-detector-key'),
        child: CodeScanListener(
          bufferDuration: const Duration(milliseconds: 200),
          onBarcodeScanned: (barcode) {
            if (!visible) return;
            debugPrint(barcode);
            Provider.of<SpeakProvider>(context, listen: false)
                .updateOrderNumber(int.parse(barcode));

            Provider.of<SpeakProvider>(context, listen: false).speak();
          },
          child: Stack(
            children: [
              Row(
                children: [
                  if (Provider.of<MediaProvider>(context, listen: false)
                          .getShowOrderScreen() ??
                      true)
                    const Expanded(flex: 1, child: SideBarWidget()),
                  Expanded(
                      flex: 3,
                      child: Consumer<MediaProvider>(
                          builder: (context, provider, _) {
                        return Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  Provider.of<MediaProvider>(context,
                                          listen: false)
                                      .getFilesByScreenID();
                                },
                                child: provider.isLoadingScreen
                                    ? Center(
                                        child: LoadingAnimationWidget.inkDrop(
                                          size: 50,
                                          color: ColorResources.PRIMARY_COLOR,
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: CarouselSlider.builder(
                                          carouselController:
                                              buttonCarouselController,
                                          itemCount:
                                              provider.mediaFiles?.length,
                                          itemBuilder: (BuildContext context,
                                              int index, int pageViewIndex) {
                                            return DownloadMediaBuilder(
                                              url: provider.mediaFiles!.isEmpty
                                                  ? "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4"
                                                  : "${EndPoints.baseUrl}/${provider.mediaFiles?[index].fileBaseString}",
                                              onSuccess: (snapshot) {
                                                if (provider
                                                    .mediaFiles!.isEmpty) {
                                                  return Image.asset(
                                                    Images.logo,
                                                    width: 200,
                                                  );
                                                }
                                                if (provider.mediaFiles?[index]
                                                        .type ==
                                                    2) {
                                                  vedioTimer?.cancel();
                                                  vedioTimer = Timer.periodic(
                                                      Duration(
                                                          seconds: provider
                                                                      .mediaFiles![
                                                                          index]
                                                                      .duration ==
                                                                  null
                                                              ? 60
                                                              : provider
                                                                      .mediaFiles![
                                                                          index]
                                                                      .duration! *
                                                                  60),
                                                      (Timer t) {
                                                    // if (t.tick ==
                                                    //     provider.mediaFiles![index]
                                                    //         .loopcount) {
                                                    buttonCarouselController
                                                        .nextPage();
                                                    vedioTimer?.cancel();
                                                    // }
                                                  });
                                                  return VedioPlayer(
                                                    filePath:
                                                        snapshot.filePath!,
                                                    buttonCarouselController:
                                                        buttonCarouselController,
                                                  );
                                                } else {
                                                  photoTimer?.cancel();
                                                  photoTimer = Timer.periodic(
                                                      Duration(
                                                          seconds: provider
                                                                      .mediaFiles![
                                                                          index]
                                                                      .duration ==
                                                                  null
                                                              ? 60
                                                              : provider
                                                                      .mediaFiles![
                                                                          index]
                                                                      .duration! *
                                                                  60),
                                                      (Timer t) {
                                                    print(
                                                        "photoTimer${t.tick}");
                                                    if (t.tick ==
                                                        provider
                                                            .mediaFiles![index]
                                                            .loopcount) {
                                                      photoTimer?.cancel();
                                                      buttonCarouselController
                                                          .nextPage();
                                                    }
                                                  });

                                                  return Image.file(
                                                      File(snapshot.filePath!));
                                                }
                                              },
                                              onLoading: (snapshot) {
                                                return Center(
                                                  child: LoadingAnimationWidget
                                                      .inkDrop(
                                                    size: 50,
                                                    color: ColorResources
                                                        .PRIMARY_COLOR,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          options: CarouselOptions(
                                            height: 900.h,
                                            aspectRatio: 16 / 9,
                                            viewportFraction: 1,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: false,

                                            autoPlayInterval:
                                                Duration(seconds: 3),
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.3,
                                            // onPageChanged:(c.o){} ,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            TextScroll(
                              provider.lastNews ?? "",
                              mode: TextScrollMode.endless,
                              velocity:
                                  Velocity(pixelsPerSecond: Offset(50, 0)),
                              delayBefore: Duration(milliseconds: 6000),
                              numberOfReps: 15899889521,
                              pauseBetween: Duration(milliseconds: 50),
                              style: TextStyle(
                                  color: ColorResources.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                              selectable: true,
                            )
                          ],
                        );
                      })),
                ],
              ),

              /*    Padding(
                padding: const EdgeInsets.all(18.0),
                child: IconButton(
                  icon: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.speaker,color: Colors.white,),
                      )),
                  onPressed: () async {
                    _key.currentState!.openDrawer();
                    // Provider.of<AuthProvider>(context, listen: false).logOut();
                  },
                ),
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.remove_circle),
        onPressed: () async {
          Provider.of<AuthProvider>(context, listen: false).logOutFromScreen();
        },
      ),
    );
  }
}
