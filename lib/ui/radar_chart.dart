part of ssun_chart;

class RadarChart extends StatefulWidget {
  const RadarChart({
    this.bgColor = Colors.black12,
    this.webLineWidth = 0.0,
    this.webLineColor = Colors.black,
    this.markerSize = 2.0,
    this.xLabels,
    this.xLabelColor = Colors.black,
    this.xLabelSize = 10,
    this.yMaximum = 100.0,
    this.yLabelColor = Colors.black,
    this.yLabelSize = 10,
    this.yDrawLabels = false,
    required this.data,
    super.key
  });

  final Color bgColor;
  final double webLineWidth;
  final Color webLineColor;
  final double markerSize;
  final List<String>? xLabels;
  final Color xLabelColor;
  final double xLabelSize;
  final double yMaximum;
  final Color yLabelColor;
  final double yLabelSize;
  final bool yDrawLabels;
  final RadarData data;

  @override
  State<StatefulWidget> createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadarChartCustomPainter(
        bgColor: widget.bgColor,
        webLineWidth: widget.webLineWidth,
        webLineColor: widget.webLineColor,
        markerSize: widget.markerSize,
        xLabels: widget.xLabels,
        xLabelColor: widget.xLabelColor,
        xLabelSize: widget.xLabelSize,
        yMaximum: widget.yMaximum,
        yLabelColor: widget.yLabelColor,
        yLabelSize: widget.yLabelSize,
        yDrawLabels: widget.yDrawLabels,
        data: widget.data,
      ),
    );
  }
}

class _RadarChartCustomPainter extends CustomPainter {
  static const _offsetAngle = 90;

  _RadarChartCustomPainter({
    required this.bgColor,
    required this.webLineWidth,
    required this.webLineColor,
    required this.markerSize,
    required this.xLabels,
    required this.xLabelColor,
    required this.xLabelSize,
    required this.yMaximum,
    required this.yLabelColor,
    required this.yLabelSize,
    required this.yDrawLabels,
    required this.data,
  });

  final Color bgColor;
  final double webLineWidth;
  final Color webLineColor;
  final double markerSize;
  final List<String>? xLabels;
  final Color xLabelColor;
  final double xLabelSize;
  final double yMaximum;
  final Color yLabelColor;
  final double yLabelSize;
  final bool yDrawLabels;
  final RadarData data;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final axisCount = data.dataSets.isNotEmpty ? data.dataSets[0].entries.length : 0;
    const guideLineCount = 5; // TODO

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    // 가이드라인
    drawGuideLines(canvas, guideLineCount, axisCount, radius, center);

    // 축
    drawAxis(canvas, axisCount, radius, center);

    // 데이터
    drawData(canvas, axisCount, radius, center);

    // x축 라벨
    drawXLabels(canvas, axisCount, radius, center);

    // y축 라벨
    drawYLabels(canvas, guideLineCount, axisCount, radius, center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void drawGuideLines(Canvas canvas, int guideLineCount, int axisCount, double radius, Offset center) {
    for (var i = 1; i <= guideLineCount; i++) {
      for (var j = 0; j < axisCount; j++) {
        final thisRadius = radius * i / guideLineCount;
        final startAngle = _offsetAngle - 360 / axisCount * j;
        final endAngle = _offsetAngle - 360 / axisCount * (j + 1);
        // P1
        final x1 = center.dx + thisRadius * cosDeg(startAngle);
        final y1 = center.dy - thisRadius * sinDeg(startAngle);
        // P2
        final x2 = center.dx + thisRadius * cosDeg(endAngle);
        final y2 = center.dy - thisRadius * sinDeg(endAngle);

        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..strokeWidth = webLineWidth
            ..color = webLineColor
        );
      }
    }
  }

  void drawAxis(Canvas canvas, int axisCount, double radius, Offset center) {
    for (var i = 0; i < axisCount; i++) {
      final startAngle = _offsetAngle - 360 / axisCount * i;
      final x1 = center.dx + radius * cosDeg(startAngle);
      final y1 = center.dy - radius * sinDeg(startAngle);

      canvas.drawLine(
        Offset(x1, y1),
        center,
        Paint()
          ..strokeWidth = webLineWidth
          ..color = webLineColor
      );
    }
  }

  void drawXLabels(Canvas canvas, int axisCount, double radius, Offset center) {
    for (var i = 0; i < (xLabels?.length ?? 0); i++) {
      final startAngle = _offsetAngle - 360 / axisCount * i;
      final x1 = center.dx + radius * cosDeg(startAngle);
      final y1 = center.dy - radius * sinDeg(startAngle);

      final textPainter = TextPainter()
        ..text = TextSpan(
          text: xLabels![i],
          style: TextStyle(
            color: xLabelColor,
            fontSize: xLabelSize
          )
        )
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      textPainter.paint(
        canvas,
        Offset(
          x1 - textPainter.width / 2,
          y1 - textPainter.height / 2
        )
      );
    }
  }

  void drawYLabels(Canvas canvas, int guideLineCount, int axisCount, double radius, Offset center) {
    if (yDrawLabels) {
      final x1 = center.dx + radius * cosDeg(_offsetAngle);
      for (var i = 0; i <= guideLineCount; i++) {
        final y1 = center.dy - radius / guideLineCount * (guideLineCount - i) *
          sinDeg(_offsetAngle);
        final textPainter = TextPainter()
          ..text = TextSpan(
            text: (yMaximum / guideLineCount * (guideLineCount - i))
              .toString(),
            style: TextStyle(
              color: yLabelColor,
              fontSize: yLabelSize
            )
          )
          ..textDirection = TextDirection.ltr
          ..textAlign = TextAlign.center
          ..layout();

        textPainter.paint(
            canvas,
            Offset(
              x1 - textPainter.width / 2,
              y1 - textPainter.height / 2
            )
        );
      }
    }
  }

  void drawData(Canvas canvas, int axisCount, double radius, Offset center) {
    for (var i = 0; i < data.dataSets.length; i++) {
      final entry = data.dataSets[i];
      final fillPath = Path();
      for (var j = 0; j < entry.entries.length; j++) {
        final v1 = entry.entries[j].value;
        final v2 = entry.entries[j == entry.entries.length - 1 ? 0 : j + 1].value;
        final startAngle = _offsetAngle - 360 / axisCount * j;
        final endAngle = _offsetAngle - 360 / axisCount * (j + 1);

        // P1
        final x1 = center.dx + (radius * v1 / yMaximum) * cosDeg(startAngle);
        final y1 = center.dy - (radius * v1 / yMaximum) * sinDeg(startAngle);
        // P2
        final x2 = center.dx + (radius * v2 / yMaximum) * cosDeg(endAngle);
        final y2 = center.dy - (radius * v2 / yMaximum) * sinDeg(endAngle);

        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..strokeWidth = entry.lineWidth
            ..color = entry.color
        );

        canvas.drawCircle(
          Offset(x1, y1),
          markerSize,
          Paint()
            ..color = entry.color
        );

        if (j == 0) {
          fillPath.moveTo(x1, y1);
        } else {
          fillPath.lineTo(x1, y1);
        }
      }
      canvas.drawPath(fillPath, Paint()..color = entry.fillColor);
    }
  }
}