/*
 * @Description: 
 * @Author: tharindu
 */
import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBloc.dart';
import 'package:ust_candlestick/packages/bloc/klineBlocProvider.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';

class KlineVolumeGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);

    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        return CustomPaint(
          size: Size.infinite,
          painter: _VolumeGridPainter(bloc.volumeMax),
        );
      },
    );
  }
}

class _VolumeGridPainter extends CustomPainter {
  final double maxVolume;
  _VolumeGridPainter(
    this.maxVolume,
  );
  final Color lineColor = kGridLineColor;
  final double lineWidth = kGridLineWidth;
  final double columnTopMargin = kColumnTopMargin;
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    // Draw a horizontal line
    canvas.drawLine(Offset(0, columnTopMargin), Offset(width, columnTopMargin), linePaint);
    canvas.drawLine(Offset(0, height), Offset(width, height), linePaint);
    // Draw vertical lines
    double widthOffset = (width ~/ kGridColumCount).toDouble();
    for (int i = 1; i < kGridColumCount; i++) {
      canvas.drawLine(Offset(i * widthOffset, columnTopMargin),
          Offset(i * widthOffset, height), linePaint);
    }
    if (maxVolume == null) {
      return;
    }
    // Draw the current maximum
    double orginX =
        width - maxVolume.toStringAsPrecision(kGridPricePrecision).length * 6;
    _drawText(canvas, Offset(orginX, columnTopMargin),
        maxVolume.toStringAsPrecision(kGridPricePrecision));
  }

  _drawText(Canvas canvas, Offset offset, String text) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: kGridTextColor,
            fontSize: kGridPriceFontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return maxVolume != null;
  }
}
