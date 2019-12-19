/*
 * @Description: 
 * @Author: tharindu
 */

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBloc.dart';
import 'package:ust_candlestick/packages/bloc/klineBlocProvider.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';
import 'package:ust_candlestick/packages/view/klineWidget.dart';

class KlinePageWidget extends StatelessWidget {
  final KlineBloc bloc;
  KlinePageWidget(this.bloc);
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    bool isScale = false;
    bool isLongPress = false;
    bool isHorizontalDrag = false;
    double screenWidth = MediaQuery.of(context).size.width;
    _showCrossWidget(Offset offset) {
      if (isScale || isHorizontalDrag) {
        return;
      }
      isLongPress = true;
      int singleScreenCandleCount =
          bloc.getSingleScreenCandleCount(screenWidth);
      int offsetCount =
          ((offset.dx / screenWidth) * singleScreenCandleCount).toInt();
      // print('offsetCount :$offsetCount length: ${bloc.klineCurrentList.length}');
      if (offsetCount > bloc.klineCurrentList.length - 1) {
        return;
      }
      int index = bloc.klineCurrentList.length - 1 - offsetCount;

      if (index < bloc.klineCurrentList.length) {
        Market market = bloc.klineCurrentList[index];
        market.isShowCandleInfo = true;
        RenderBox candleWidgetRenderBox =
            bloc.candleWidgetKey.currentContext.findRenderObject();
        Offset candleWidgetOriginOffset =
            candleWidgetRenderBox.localToGlobal(Offset.zero);

        RenderBox currentWidgetRenderBox = context.findRenderObject();
        Offset currentWidgetOriginOffset =
            currentWidgetRenderBox.localToGlobal(Offset.zero);

        RenderBox volumeWidgetRenderBox = bloc.volumeWidgetKey.currentContext.findRenderObject();

        market.candleWidgetOriginY =
            candleWidgetOriginOffset.dy - currentWidgetOriginOffset.dy;
        market.gridTotalHeight = candleWidgetRenderBox.size.height + volumeWidgetRenderBox.size.height;
        // print('${candleWidgetRenderBox.size} ${volumeWidgetRenderBox.size}');
        bloc.marketSinkAdd(market);
      }
    }

    _hiddenCrossWidget() {
      isLongPress = false;
      bloc.marketSinkAdd(
          Market(null, null, null, null, null,null, isShowCandleInfo: false));
    }

    _horizontalDrag(Offset offset) {
      if (isScale || isLongPress) {
        return;
      }
      isHorizontalDrag = true;
      double offsetX = offset.dx - lastPoint.dx;
      int singleScreenCandleCount =
          bloc.getSingleScreenCandleCount(screenWidth);
      // The number of current offsets
      int offsetCount =
          ((offsetX / screenWidth) * singleScreenCandleCount).toInt();
      if (offsetCount == 0) {
        return;
      }
      int firstScreenNum =
          (singleScreenCandleCount * bloc.getFirstScreenScale()).toInt();
      if (bloc.klineTotalList.length > firstScreenNum) {
        // Current total number of offsets
        int currentOffsetCount = bloc.toIndex + offsetCount;
        int totalListLength = bloc.klineTotalList.length;
        currentOffsetCount = min(currentOffsetCount, totalListLength);
        if (currentOffsetCount < firstScreenNum) {
          return;
        }
        int fromIndex = 0;
        // print('fromIndex: $fromIndex');

        // If the number of current offsets does not reach the number displayed on one screen, then the data is taken from 0.
        if (currentOffsetCount > singleScreenCandleCount) {
          fromIndex = (currentOffsetCount - singleScreenCandleCount);
        }
        lastPoint = offset;
        bloc.getSubKlineList(fromIndex, currentOffsetCount);
        // print('fromIndex: $fromIndex  currentOffsetCount: $currentOffsetCount');
      }
    }

    _scaleUpdate(double scale) {
      if (isHorizontalDrag || isLongPress) {
        return;
      }
      isScale = true;
      if (scale > 1 && (scale - 1) > 0.03) {
        scale = 1.03;
      } else if (scale < 1 && (1 - scale) > 0.03) {
        scale = 0.97;
      }
      double candlestickWidth = scale * bloc.candlestickWidth;
      bloc.setCandlestickWidth(candlestickWidth);
      // print('bloc.candlestickWidth : ${bloc.candlestickWidth}');
      double count = (screenWidth - bloc.candlestickWidth) /
          (kCandlestickGap + bloc.candlestickWidth);
      int currentScreenCountNum = count.toInt();

      int toIndex = bloc.toIndex;
      int fromIndex = toIndex - currentScreenCountNum;
      fromIndex = max(0, fromIndex);

      // print('from: $fromIndex   to: $toIndex  currentScreenCountNum: $currentScreenCountNum');
      bloc.getSubKlineList(fromIndex, toIndex);
    }

    return KlineBlocProvider<KlineBloc>(
      bloc: bloc,
      child: GestureDetector(
        onTap: () {
          if (isLongPress) {
            _hiddenCrossWidget();
          } 
        },
        /// Press
        onLongPressStart: (longPressDragStartDetail) {
          _showCrossWidget(longPressDragStartDetail.globalPosition);
          // print('onLongPressDragStart');
        },
        onLongPressMoveUpdate: (longPressDragUpdateDetail) {
          _showCrossWidget(longPressDragUpdateDetail.globalPosition);
          // print('onLongPressDragUpdate');
        },

        /// Horizontal drag
        onHorizontalDragDown: (horizontalDragDown) {
          if (isLongPress) {
            _hiddenCrossWidget();
          }
          lastPoint = horizontalDragDown.globalPosition;
        },
        onHorizontalDragUpdate: (details) {
          _horizontalDrag(details.globalPosition);
        },
        onHorizontalDragEnd: (_) {
          isHorizontalDrag = false;
        },
        onHorizontalDragCancel: () {
          isHorizontalDrag = false;
        },
        onScaleStart: (_) {
          isScale = true;
        },

        /// Zoom
        onScaleUpdate: (details) {
          if (isLongPress) {
            _hiddenCrossWidget();
          }
          _scaleUpdate(details.scale);
        },
        onScaleEnd: (_) {
          isScale = false;
        },

        child: StreamBuilder(
          stream: bloc.klineListStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
            List<Market> listData = snapshot.data;
            if (listData != null) {
              bloc.setScreenWidth(screenWidth);
            }
            return KlineWidget();
          },
        ),
      ),
    );
  }
}
