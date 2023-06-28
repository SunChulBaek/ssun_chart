part of ssun_chart;

class LineChart extends StatefulWidget {
  const LineChart({
    this.bgColor = Colors.black12,
    this.markerSize = 2.0,
    this.drawMarker = false,
    this.yMaximum = 100,
    required this.data,
    super.key
  });

  final Color bgColor;
  final double markerSize;
  final bool drawMarker;
  final double yMaximum;
  final LineData data;

  @override
  State<StatefulWidget> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartCustomPaint(
        bgColor: widget.bgColor,
        markerSize: widget.markerSize,
        drawMarker: widget.drawMarker,
        yMaximum: widget.yMaximum,
        data: widget.data,
      ),
    );
  }
}

class _LineChartCustomPaint extends CustomPainter {
  static const double xMargin = 10;
  static const double yMargin = 10;

  _LineChartCustomPaint({
    required this.bgColor,
    required this.markerSize,
    required this.drawMarker,
    required this.yMaximum,
    required this.data,
  });

  final Color bgColor;
  final double markerSize;
  final bool drawMarker;
  final double yMaximum;
  final LineData data;

  @override
  void paint(Canvas canvas, Size size) {
    final anchor = Offset(xMargin, size.height - yMargin); // x축, y축 만나는 지점
    const yGuideLineCount = 5;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    // 데이터
    drawData(canvas, size, anchor);

    // X축
    drawXAxis(canvas, size, anchor);

    // y축
    drawYAxis(canvas, size, anchor);

    // y축 GuideLine
    drawYGuideLines(canvas, size, anchor, yGuideLineCount);

    // y축 Label
    drawYLabels(canvas, size, anchor, yGuideLineCount);
  }

  void drawXAxis(Canvas canvas, Size size, Offset anchor) {
    canvas.drawLine(
      anchor,
      Offset(size.width - xMargin, anchor.dy),
      Paint()..color = Colors.black
    );
  }

  void drawYAxis(Canvas canvas, Size size, Offset anchor) {
    canvas.drawLine(
      anchor,
      Offset(anchor.dx, yMargin),
      Paint()..color = Colors.black
    );
  }

  void drawYGuideLines(Canvas canvas, Size size, Offset anchor, int yGuideLineCount) {
    for (int i = 0; i < yGuideLineCount; i++) {
      final y = anchor.dy - (size.height - yMargin * 2) / yGuideLineCount * i;
      canvas.drawLine(
          Offset(anchor.dx, y),
          Offset(size.width - xMargin, y),
          Paint()..color = Colors.black
      );
    }
  }

  void drawYLabels(Canvas canvas, Size size, Offset anchor, int yGuideLineCount) {
    for (int i = 0; i <= yGuideLineCount; i++) {
      final y = anchor.dy - (size.height - yMargin * 2) / yGuideLineCount * i;
      final textPainter = TextPainter()
        ..text = TextSpan(
            text: (yMaximum / yGuideLineCount * i).toString(),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 10
            )
        )
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      textPainter.paint(
          canvas,
          Offset(
              anchor.dx - textPainter.width / 2,
              y - textPainter.height / 2
          )
      );
    }
  }

  void drawData(Canvas canvas, Size size, Offset anchor) {
    for (int i = 0; i < data.dataSets.length; i++) {
      final entry = data.dataSets[i];
      final fillPath = Path();
      double minY = double.infinity;
      for (int j = 0; j < entry.entries.length - 1; j++) {
        final v1 = entry.entries[j].value;
        final v2 = entry.entries[j + 1].value;
        // p1
        final x1 = anchor.dx + (size.width - anchor.dx - xMargin) / (entry.entries.length - 1) * j;
        final y1 = anchor.dy - (anchor.dy - yMargin) / yMaximum * v1;
        // p2
        final x2 = anchor.dx + (size.width - anchor.dx - xMargin) / (entry.entries.length - 1) * (j + 1);
        final y2 = anchor.dy - (anchor.dy - yMargin) / yMaximum * v2;

        if (y1 < minY) {
          minY = y1;
        }
        if (y2 < minY) {
          minY = y2;
        }

        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..strokeWidth = entry.lineWidth
            ..color = entry.color
        );

        if (drawMarker) {
          if (j == 0) {
            canvas.drawCircle(
              Offset(x1, y1),
              markerSize,
              Paint()
                ..color = entry.color
            );
          }
          canvas.drawCircle(
            Offset(x2, y2),
            markerSize,
            Paint()
              ..color = entry.color
          );
        }

        if (j == 0) {
          fillPath.moveTo(anchor.dx, anchor.dy);
          fillPath.lineTo(x1, y1);
        }
        fillPath.lineTo(x2, y2);
        if (j == entry.entries.length - 2) {
          fillPath.lineTo(size.width - xMargin, anchor.dy);
          fillPath.lineTo(anchor.dx, anchor.dy);
        }
      }
      // canvas.drawPath(
      //   fillPath,
      //   Paint()
      //     ..shader = ui.Gradient.linear(
      //       Offset(anchor.dx, minY),
      //       Offset(anchor.dx, anchor.dy),
      //       [
      //         entry.color,
      //         Colors.white
      //       ]
      //     )
      // );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}