part of ssun_chart;

class BarChart extends StatefulWidget {
  const BarChart({
    this.bgColor = Colors.black12,
    this.yMaximum = 100,
    required this.data,
    super.key
  });

  final Color bgColor;
  final double yMaximum;
  final BarData data;

  @override
  State<StatefulWidget> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartCustomPainter(
        bgColor: widget.bgColor,
        yMaximum: widget.yMaximum,
        data: widget.data,
      ),
    );
  }
}

class _BarChartCustomPainter extends CustomPainter {
  static const double xMargin = 10;
  static const double yMargin = 10;
  static const double setMargin = 10;
  static const double barMargin = 3;

  _BarChartCustomPainter({
    required this.bgColor,
    required this.yMaximum,
    required this.data,
  });

  final Color bgColor;
  final double yMaximum;
  final BarData data;

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
      for (int j = 0; j < entry.entries.length; j++) {
        final v = entry.entries[j].value;
        final setWidth = (size.width - anchor.dx - xMargin) / entry.entries.length;
        final barWidth = (setWidth - setMargin) / data.dataSets.length;
        // p1
        final x1 = anchor.dx + (setWidth * j) + (barWidth * i);
        // p2
        final x2 = x1 + barWidth;
        final y2 = anchor.dy - (anchor.dy - yMargin) / yMaximum * v;

        canvas.drawRect(
          Rect.fromLTRB(x1, y2, x2 - barMargin, anchor.dy),
          Paint()..color = entry.color
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}