/*
 * @Description: 
 * @Author: tharindu
 */

import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBloc.dart';
import 'package:ust_candlestick/packages/bloc/klineBlocProvider.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';

class KlineVolumeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        return CustomPaint(
          key: bloc.volumeWidgetKey,
          size: Size(bloc.screenWidth, bloc.screenWidth / kVolumeAspectRatio),
          painter: _KlineVolumePainter(
              snapshot.data, bloc.volumeMax, bloc.candlestickWidth),
        );
      },
    );
  }
}

class _KlineVolumePainter extends CustomPainter {
  final List<Market> listData;
  final double maxVolume;
  _KlineVolumePainter(
    this.listData,
    this.maxVolume,
    this.columnarWidth,
  );

  /// Column width
  final double columnarWidth;

  /// Clearance between columns = gap between candlesticks
  final double columnarGap = kColumnarGap;
  final double columnarTopMargin = kColumnarTopMargin;
  final Color increaseColor = kIncreaseColor;
  final Color decreaseColor = kDecreaseColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (listData == null || maxVolume == null || maxVolume == 0) {
      return;
    }
    double height = size.height - columnarTopMargin;
    final double heightVolumeOffset = height / maxVolume;
    double columnarRectLeft;
    double columnarRectTop;
    double columnarRectRight;
    double columnarRectBottom;

    Paint columnarPaint;

    for (int i = 0; i < listData.length; i++) {
      Market market = listData[i];
      // brush
      Color painterColor;
      if (market.open > market.close) {
        painterColor = decreaseColor;
      } else if (market.open == market.close) {
        painterColor = Colors.white;
      } else {
        painterColor = increaseColor;
      }
      columnarPaint = Paint()
        ..color = painterColor
        ..strokeWidth = columnarWidth
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high;

      // Columnar body
      int j = listData.length - 1 - i;
      columnarRectLeft = j * (columnarWidth + columnarGap) + columnarGap;
      columnarRectRight = columnarRectLeft + columnarWidth;
      columnarRectTop =
          height - market.vol * heightVolumeOffset + columnarTopMargin;
      columnarRectBottom = height + columnarTopMargin;
      // print('columnarRectTop : $columnarRectTop   columnarRectBottom: $columnarRectBottom');
      Rect columnarRect = Rect.fromLTRB(columnarRectLeft, columnarRectTop,
          columnarRectRight, columnarRectBottom);
      canvas.drawRect(columnarRect, columnarPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return listData != null;
  }
}
