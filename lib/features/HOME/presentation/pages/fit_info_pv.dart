import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';
import 'package:sorted/features/HOME/presentation/pages/affirmation_pv.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';

class FitInfoPV extends StatefulWidget {
  final TrackModel trackModel;
  final TrackSummary summary;

  FitInfoPV({Key key, this.trackModel, this.summary}) : super(key: key);

  @override
  _FitInfoPVState createState() => _FitInfoPVState();
}

class _FitInfoPVState extends State<FitInfoPV> {
  var _pageNotifier = ValueNotifier(0.0);
  PageController _pageController;
  void _listener() {
    _pageNotifier.value = _pageController.page;
  }

  _FitInfoPVState() {
    print("jj");
    _pageController =
        PageController(viewportFraction: 1.0, initialPage: 0, keepPage: true);

    _pageNotifier = ValueNotifier(0.0);
    //_pageController.addListener(_listener);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _pageController.addListener(_listener);
    // });
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();

    _pageNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SafeArea(
        child: Stack(
          children: [
            Center(
                child: ValueListenableBuilder<double>(
              valueListenable: _pageNotifier,
              builder: (_, value, child) => PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (int page) {},
                  itemCount: widget.trackModel.carousel.length,
                  itemBuilder: (context, position) {
                    return Stack(
                      children: [
                        Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.trackModel.carousel[position],
                                  placeholder: (context, url) =>
                                      ImagePlaceholderWidget(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.network_check),
                                  fit: BoxFit.cover,
                                  height: Gparam.height,
                                  width: Gparam.width,
                                ))),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.grey.withOpacity(0.1),
                            alignment: Alignment.center,
                            child: Text(''),
                          ),
                        ),
                        Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.trackModel.carousel[position],
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.network_check),
                                  fit: BoxFit.scaleDown,
                                  height: Gparam.height,
                                  width: Gparam.width,
                                ))),
                      ],
                    );
                  }),
            )),
          ],
        ),
      ),
    ));
  }
}
