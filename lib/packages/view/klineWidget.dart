/*
 * @Description: 
 * @Author: tharindu
 */

import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';
import 'package:ust_candlestick/packages/view/grid/klinePriceGridWidget.dart';
import 'package:ust_candlestick/packages/view/grid/klineVolumeGridWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klineCandleCrossWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klineCandleInfoWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klineCandleWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klineLoadingWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klineMaLineWidget.dart';
import 'package:ust_candlestick/packages/view/kline/klinePeriodSwitch.dart';
import 'package:ust_candlestick/packages/view/kline/klineVolumeWidget.dart';

class KlineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _getTotalAspectRatio(
          context, kcandleAspectRatio, kVolumeAspectRatio, kPeriodAspectRatio),
      child: Container(
        color: kBackgroundColor,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  child: KlinePeriodSwitchWidget(),
                  aspectRatio: kPeriodAspectRatio,
                ),
                AspectRatio(
                  aspectRatio: kcandleAspectRatio,
                  child: Stack(
                    children: <Widget>[
                      KlinePriceGridWidget(),
                      KlineCandleWidget(),
                      // KlineMaLineWidget(YKMAType.MA5),
                      // KlineMaLineWidget(YKMAType.MA10),
                      // KlineMaLineWidget(YKMAType.MA30),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: kVolumeAspectRatio,
                  child: Stack(
                    children: <Widget>[
                      KlineVolumeGridWidget(),
                      KlineVolumeWidget(),
                    ],
                  ),
                ),
              ],
            ),
            KlineCandleCrossWidget(),
            KlineCandleInfoWidget(),
            KlineLoadingWidget(),
          ],
        ),
      ),
    );
  }
}

double _getTotalAspectRatio(
    BuildContext context, double aspectRatio1, aspectRatio2, aspectRatio3) {
  if (aspectRatio1 == 0 || aspectRatio2 == 0 || aspectRatio3 == 0) {
    return 1;
  }
  double width = MediaQuery.of(context).size.width;
  // width/height1 = aspectRatio1; height1 = width/aspectRatio1;
  double height1 = width / aspectRatio1;
  double height2 = width / aspectRatio2;
  double heitht3 = width / aspectRatio3;
  return width / (height1 + height2 + heitht3);
}
