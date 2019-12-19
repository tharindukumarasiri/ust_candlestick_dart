/*
 * @Description: 
 * @Author: tharindu
 */
import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBloc.dart';
import 'package:ust_candlestick/packages/bloc/klineBlocProvider.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';
import 'package:ust_candlestick/packages/model/klineConstrants.dart';

class KlinePriceGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = KlineBlocProvider.of<KlineBloc>(context);

    return StreamBuilder(
      stream: klineBloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        return CustomPaint(
          size: Size.infinite,
          painter: _KlineGridPainter(klineBloc.priceMax, klineBloc.priceMin),
        );
      },
    );
  }
}

class _KlineGridPainter extends CustomPainter {
  final double max;
  final double min;
  _KlineGridPainter(this.max, this.min);

  final double lineWidth = kGridLineWidth;
  final Color lineColor = kGridLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height - kTopMargin;
    double width = size.width;
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    //Draw horizontal line / price
    double heightOffset = height / kGridRowCount;
    for (var i = 0; i < kGridRowCount + 1; i++) {
      canvas.drawLine(Offset(0, kTopMargin + heightOffset * i),
          Offset(width, kTopMargin + heightOffset * i), linePaint);
    }
    // Draw vertical line
    // double widthOffset = (width ~/ kGridColumCount).toDouble();
    // for (int i = 1; i < kGridColumCount; i++) {
    //   canvas.drawLine(Offset(i * widthOffset, 0),
    //       Offset(i * widthOffset, height + kTopMargin), linePaint);
    // }
    if (max == null || min == null) {
      return;
    }
    double priceOffset = (max - min) / kGridRowCount;
    double priceOriginX = width;
    // The font is a 10th word, but in fact the height of the font will be greater than 10, so add 3
    double textHeight = kGridPriceFontSize + 3;
    for (var i = 0; i < kGridRowCount + 1; i++) {
      double originY = kTopMargin + heightOffset * i - textHeight;
      if (i == 0) {
        originY = kTopMargin;
      }
      _drawText(
          canvas,
          Offset(priceOriginX, originY),
          (min + priceOffset * (kGridRowCount - i))
              .toStringAsPrecision(kGridPricePrecision));
    }
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
    Offset of = Offset(offset.dx - textPainter.width, offset.dy);
    textPainter.paint(canvas, of);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return max != null && min != null;
  }
}
