/*
 * @Author: tharindu
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBlocProvider.dart';
import 'package:ust_candlestick/packages/manager/klineDataManager.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';
import 'package:rxdart/rxdart.dart';

class KlineBloc extends KlineBlocBase {
  // A few inflows and outflows
  BehaviorSubject<List<Market>> _klineListSubject =
      BehaviorSubject<List<Market>>();
  Sink<List<Market>> get _klineListSink => _klineListSubject.sink;
  Stream<List<Market>> get klineListStream => _klineListSubject.stream;

  // Some inflows and outflows
  PublishSubject<List<Market>> _klineCurrentListSubject =
      PublishSubject<List<Market>>();
  Sink<List<Market>> get _currentKlineListSink => _klineCurrentListSubject.sink;
  Stream<List<Market>> get currentKlineListStream =>
      _klineCurrentListSubject.stream;

  // Click to get a single k-line data
  PublishSubject<Market> _klineMarketSubject = PublishSubject<Market>();
  Sink<Market> get _klineMarketSink => _klineMarketSubject.sink;
  Stream<Market> get klineMarketStream => _klineMarketSubject.stream;

  // periodSwitch
  PublishSubject<String> _klinePeriodSwitchSubject = PublishSubject<String>();
  Sink<String> get _klinePeriodSwitchSink => _klinePeriodSwitchSubject.sink;
  Stream<String> get _klinePeriodSwitchStream => _klinePeriodSwitchSubject.stream;

  // showloading
  PublishSubject<bool> _klineShowLoadingSubject = PublishSubject<bool>();
  Sink<bool> get _klineShowLoadingSink => _klineShowLoadingSubject.sink;
  Stream<bool> get klineShowLoadingStream => _klineShowLoadingSubject.stream;

  /// Kline data displayed on a single screen
  List<Market> klineCurrentList = List();
  /// Total data
  List<Market> klineTotalList = List();

  double screenWidth = 375;
  double priceMax;
  double priceMin;

  double pMax;
  double pMin;

  double volumeMax;
  int firstScreenCandleCount;
  double candlestickWidth = kCandlestickWidth;

  GlobalKey candleWidgetKey = GlobalKey();
  GlobalKey volumeWidgetKey = GlobalKey();

  /// The starting position of the current K line slip
  int fromIndex;

  /// The end position of the current K line slip
  int toIndex;

  KlineBloc() {
    initData();
    _klinePeriodSwitchStream.listen(periodSwitch);
  }
  void periodSwitch(String period) {}
  void initData() {}

  @override
  void dispose() {
    _klineListSubject.close();
    _klineCurrentListSubject.close();
    _klineMarketSubject.close();
    _klinePeriodSwitchSubject.close();
    _klineShowLoadingSubject.close();
  }

  void updateDataList(List<Market> dataList) {
    if (dataList != null && dataList.length > 0) {
      klineTotalList.clear();
      klineTotalList =
          KlineDataManager.calculateKlineData(YKChartType.MA, dataList);
      _klineListSink.add(klineTotalList);
    }
  }

  void setCandlestickWidth(double scaleWidth) {
    if (scaleWidth > 25 || scaleWidth < 2) {
      return;
    }
    candlestickWidth = scaleWidth;
  }

  int getSingleScreenCandleCount(double width) {
    screenWidth = width;
    double count =
        (screenWidth - kCandlestickGap) / (candlestickWidth + kCandlestickGap);
    int totalScreenCountNum = count.toInt();
    return totalScreenCountNum;
  }

  double getFirstScreenScale() {
    return (kGridColumCount - 1) / kGridColumCount;
  }

  void setScreenWidth(double width) {
    screenWidth = width;
    int singleScreenCandleCount = getSingleScreenCandleCount(screenWidth);
    int maxCount = this.klineTotalList.length;
    int firstScreenNum =
        (getFirstScreenScale() * singleScreenCandleCount).toInt();
    if (singleScreenCandleCount > maxCount) {
      firstScreenNum = maxCount;
    }
    firstScreenCandleCount = firstScreenNum;

    getSubKlineList(0, firstScreenCandleCount);
  }

  void getSubKlineList(int from, int to) {
    fromIndex = from;
    toIndex = to;
    List<Market> list = this.klineTotalList;
    klineCurrentList.clear();
    klineCurrentList = list.sublist(from, to);
    _calculateCurrentKlineDataLimit();
    _currentKlineListSink.add(klineCurrentList);
  }

  void _calculateCurrentKlineDataLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _pMax = -double.infinity;
    double _pMin = double.infinity;
    double _volumeMax = -double.infinity;
    for (var item in klineCurrentList) {
      _volumeMax = max(item.vol, _volumeMax);

      _priceMax = max(_priceMax, item.high);
      _priceMin = min(_priceMin, item.low);

      _pMax = max(_pMax, item.high);
      _pMin = min(_pMin, item.low);

      /// Calculate the highest and lowest price by comparing with the daily average data of x
      if (item.priceMa1 != null) {
        _priceMax = max(_priceMax, item.priceMa1);
        _priceMin = min(_priceMin, item.priceMa1);
      }
      if (item.priceMa2 != null) {
        _priceMax = max(_priceMax, item.priceMa2);
        _priceMin = min(_priceMin, item.priceMa2);
      }
      if (item.priceMa3 != null) {
        _priceMax = max(_priceMax, item.priceMa3);
        _priceMin = min(_priceMin, item.priceMa3);
      }
      pMax = _pMax;
      pMin = _pMin;
      priceMax = _priceMax;
      priceMin = _priceMin;
      volumeMax = _volumeMax;

      // print('priceMax : $priceMax');
      // print('priceMax : $priceMax priceMin: $priceMin volumeMax: $volumeMax');
    }
  }

  void marketSinkAdd(Market market) {
    if (market != null) {
      _klineMarketSink.add(market);
    }
  }
  void periodSwitchSinkAdd(String period) {
    if (period != null) {
      _klinePeriodSwitchSink.add(period);
    }
  }

  void showLoadingSinkAdd(bool show) {
    // if (show != null) {
    _klineShowLoadingSink.add(show);
    // }
  }
}
