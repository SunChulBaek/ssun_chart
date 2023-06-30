part of ssun_chart;

class PieChart extends StatefulWidget {
  const PieChart({
    this.bgColor = Colors.black12,
    this.usePercentValues = false,
    // center text
    this.drawCenterText = false,
    this.centerText = "",
    this.centerTextColor = Colors.black,
    this.centerTextSize = 10,
    // hole
    this.drawHoleEnabled = false,
    this.holeColor = Colors.white,
    this.holeRadius = 10,
    // transparent circle
    this.transparentCircleColor = Colors.white10,
    this.transparentCircleRadius = 20,
    this.transparentCircleOpacity = 0.3,
    // label
    this.entryLabelColor = Colors.black,
    this.entryLabelTextSize = 10,
    required this.data,
    super.key,
  });

  final Color bgColor;
  final bool usePercentValues;
  // center text
  final bool drawCenterText;
  final String centerText;
  final Color centerTextColor;
  final double centerTextSize;
  // hole
  final bool drawHoleEnabled;
  final Color holeColor;
  final double holeRadius;
  // transparent circle
  final Color transparentCircleColor;
  final double transparentCircleRadius;
  final double transparentCircleOpacity;
  // label
  final Color entryLabelColor;
  final double entryLabelTextSize;
  final PieData data;

  @override
  State<StatefulWidget> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PieChartCustomPainter(
        bgColor: widget.bgColor,
        usePercentValues: widget.usePercentValues,
        centerText: widget.centerText,
        centerTextColor: widget.centerTextColor,
        centerTextSize: widget.centerTextSize,
        drawCenterText: widget.drawCenterText,
        drawHoleEnabled: widget.drawHoleEnabled,
        holeColor: widget.holeColor,
        holeRadius: widget.holeRadius,
        transparentCircleColor: widget.transparentCircleColor,
        transparentCircleRadius: widget.transparentCircleRadius,
        transparentCircleOpacity: widget.transparentCircleOpacity,
        entryLabelColor: widget.entryLabelColor,
        entryLabelTextSize: widget.entryLabelTextSize,
        data: widget.data,
      ),
    );
  }
}

class _PieChartCustomPainter extends CustomPainter {
  _PieChartCustomPainter({
    required this.bgColor,
    required this.usePercentValues,
    // center text
    required this.drawCenterText,
    required this.centerText,
    required this.centerTextColor,
    required this.centerTextSize,
    // hole
    required this.drawHoleEnabled,
    required this.holeColor,
    required this.holeRadius,
    // transparent circle
    required this.transparentCircleColor,
    required this.transparentCircleRadius,
    required this.transparentCircleOpacity,
    required this.entryLabelColor,
    required this.entryLabelTextSize,
    required this.data,
  });

  final Color bgColor;
  final bool usePercentValues;
  // center text
  final bool drawCenterText;
  final String centerText;
  final Color centerTextColor;
  final double centerTextSize;
  // hole
  final bool drawHoleEnabled;
  final Color holeColor;
  final double holeRadius;
  // transparent circle
  final Color transparentCircleColor;
  final double transparentCircleRadius;
  final double transparentCircleOpacity;
  // label
  final Color entryLabelColor;
  final double entryLabelTextSize;
  final PieData data;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    // 데이터
    drawData(canvas, radius, center);

    // 레이블
    drawLabels(canvas, radius, center);

    // center text
    drawCenterTexts(canvas, radius, center);
  }

  void drawCenterTexts(Canvas canvas, double radius, Offset center) {
    final textPainter = TextPainter()
      ..text = TextSpan(
          text: centerText,
          style: TextStyle(
            color: centerTextColor,
            fontSize: centerTextSize
          )
      )
      ..textDirection = ui.TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    textPainter.paint(
        canvas,
        Offset(
            center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2
        )
    );
  }

  void drawLabels(Canvas canvas, double radius, Offset center) {
    const offsetAngle = 90;
    const factor = 0.6;
    for (var i = 0; i < data.dataSets.length; i++) {
      final entry = data.dataSets[i];
      for (var j = 0; j < entry.entries.length; j++) {
        final total = entry.entries.fold(0.0, (prev, e) => prev + e.value);
        final startAngle = offsetAngle - 360 / total *
            (j == 0 ? 0 : entry.entries.sublist(0, j).fold(
                0.0, (prev, e) => prev + e.value));
        final endAngle = offsetAngle - 360 / total *
            entry.entries.sublist(0, j + 1).fold(
                0.0, (prev, e) => prev + e.value);

        final x = center.dx + (radius * factor) * cosDeg((startAngle + endAngle) / 2);
        final y = center.dy - (radius * factor) * sinDeg((startAngle + endAngle) / 2);

        final textPainter = TextPainter()
          ..text = TextSpan(
            text: "${entry.entries[j].label}${usePercentValues ? "\n${NumberFormat("#,###.##").format(entry.entries[j].value)}%" : ""}",
            style: TextStyle(
              color: entryLabelColor,
              fontSize: entryLabelTextSize
            )
          )
          ..textDirection = ui.TextDirection.ltr
          ..textAlign = TextAlign.center
          ..layout();

        textPainter.paint(
          canvas,
          Offset(
            x - textPainter.width / 2,
            y - textPainter.height / 2
          )
        );
      }
    }
  }

  void drawData(Canvas canvas, double radius, Offset center) {
    const offsetAngle = -90;
    if (drawHoleEnabled) {
      canvas.saveLayer(
        Rect.fromCircle(center: center, radius: radius),
        Paint()
      );
    }
    for (var i = 0; i < data.dataSets.length; i++) {
      final entry = data.dataSets[i];
      for (var j = 0; j < entry.entries.length; j++) {
        final fillPath = Path();
        final total = entry.entries.fold(0.0, (prev, e) => prev + e.value);
        final startAngle = offsetAngle + 360 / total * (j == 0 ? 0 : entry.entries.sublist(0, j).fold(0.0, (prev, e) => prev + e.value));
        final endAngle = offsetAngle + 360 / total * entry.entries.sublist(0, j + 1).fold(0.0, (prev, e) => prev + e.value);

        fillPath.moveTo(center.dx, center.dy);
        fillPath.lineTo(
          center.dx + radius * cosDeg(startAngle),
          center.dy - radius * sinDeg(startAngle)
        );
        fillPath.arcTo(
          Rect.fromCircle(center: center, radius: radius),
          degToRad(startAngle).toDouble(),
          degToRad(endAngle - startAngle).toDouble(),
          true
        );
        fillPath.lineTo(center.dx, center.dy);
        canvas.drawPath(fillPath, Paint()..color = data.dataSets[i].colors[j]);
      }
    }

    canvas.drawCircle(
      center,
      transparentCircleRadius,
      Paint()..color = transparentCircleColor
          .withOpacity(transparentCircleOpacity)
    );

    if (drawHoleEnabled) {
      canvas.drawCircle(center, holeRadius, Paint()..color = holeColor);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}