/*
 * @Description: 
 * @Author: tharindu
 */

import 'package:flutter/material.dart';

/********************************Kline switch related configuration********************************/
///
const double kPeriodHeight = 40;
const double kPeriodAspectRatio = 375/kPeriodHeight;
const String kDefaultPeriod = '1day';
const List<String> kPeriodList = ['1min', '5min', '15min', '30min', '60min', '1day'];
const List<String> kPeriodTitleList = ['1min', '5min', '15min', '30min', '1hour', 'Daily line'];
const kDefaultPeriodIndex = 5;
/**********************************Kline related configuration**********************************/
/// Candlestick width
const double kCandlestickWidth = 7.0;
/// Wick width
const double kWickWidth = 1.0;
/// Clearance between candlesticks
const double kCandlestickGap = 2.0;
/// Above the upper shadow line
const double kTopMargin = 30.0;
const Color kDecreaseColor = Color(0xFFD32F2F);
const Color kIncreaseColor = Color(0xFF26A69A);
const Color kBackgroundColor = Colors.white;
const double kcandleAspectRatio = 1;
const Color kCandleTextColor = Colors.black;
const double kCandleFontSize = 9;
const double kCandleTextHight = 12;

/**********************************Volume related configuration**********************************/
/// Column width
const double kColumnarWidth = kCandlestickWidth;
/// Clearance between columns = gap between candlesticks
const double kColumnarGap = kCandlestickGap;
const double kColumnarTopMargin = 32.0;
const double kVolumeAspectRatio = 1/0.25;

/**********************************Grid related configuration**********************************/
/// Grid line color
const Color kGridLineColor = Color(0xff263347);
const Color kGridTextColor = Color(0xff7287A5);
const double kGridLineWidth = 0.5;
const double kGridPriceFontSize = 10;
const int kGridRowCount = 8;
const int kGridColumCount = 5;
const int kGridPricePrecision = 7;
const double kColumnTopMargin = 20.0;

/**********************************MA line related configuration**********************************/
/// Ma line width
const double kMaLineWidth = 1.0;
const double kMaTopMargin = kTopMargin;
const Color kMa5LineColor = Colors.black;
const Color kMa10LineColor = Color(0xff81CEBF);
const Color kMa20LineColor = Color(0xffC097F6);

/********************************Cross-line related configuration********************************/
///
const Color kCrossHLineColor = Colors.teal;
const Color kCrossVLineColor = Colors.black12;
const Color kCrossPointColor = Colors.white;
const double kCrossHLineWidth = 1.5;
const double kCrossVLineWidth = kCandlestickGap;
const double kCrossPointRadius = 2.0;
const double kCrossTopMargin = 0;

/********************************Single K line information related configuration********************************/
///
const Color kCandleInfoBgColor = Color(0x8A000000);
const Color kCandleInfoBorderColor = Color(0xff7286A4);
const Color kCandleInfoTextColor = Color(0xffCFD3E7);
const Color kCandleInfoDecreaseColor = kDecreaseColor;
const Color kCandleInfoIncreaseColor = kIncreaseColor;
const double kCandleInfoLeftFontSize = 10;
const double kCandleInfoRightFontSize = 10;
const double kCandleInfoLeftMargin = 5;
const double kCandleInfoTopMargin = 20;
const double kCandleInfoBorderWidth = 1;
const EdgeInsets kCandleInfoPadding = EdgeInsets.fromLTRB(5, 3, 5, 3);
const double kCandleInfoWidth = 130;
const double kCandleInfoHeight = 137;

enum YKMAType {
  MA5,
  MA10,
  MA30
}