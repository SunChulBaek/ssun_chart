part of ssun_chart;

class PieChart extends StatefulWidget {
  const PieChart({
    this.bgColor = Colors.black12,
    required this.data,
    super.key,
  });

  final Color bgColor;
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
        data: widget.data,
      ),
    );
  }
}

class _PieChartCustomPainter extends CustomPainter {
  static const _offsetAngle = -90;

  _PieChartCustomPainter({
    required this.bgColor,
    required this.data,
  });

  final Color bgColor;
  final PieData data;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = bgColor);

    // 데이터
    drawData(canvas, radius, center);
  }

  void drawData(Canvas canvas, double radius, Offset center) {
    canvas.saveLayer(Rect.fromCircle(center: center, radius: radius), Paint());
    final innerRadius = radius * 0.2;
    for (var i = 0; i < data.dataSets.length; i++) {
      final entry = data.dataSets[i];
      for (var j = 0; j < entry.entries.length; j++) {
        final fillPath = Path();
        final total = entry.entries.fold(0.0, (prev, e) => prev + e.value);
        final startAngle = _offsetAngle + 360 / total * (j == 0 ? 0 : entry.entries.sublist(0, j).fold(0.0, (prev, e) => prev + e.value));
        final endAngle = _offsetAngle + 360 / total * entry.entries.sublist(0, j + 1).fold(0.0, (prev, e) => prev + e.value);

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
    canvas.drawCircle(center, radius * 0.3, Paint()..color = Colors.white.withOpacity(0.3));
    canvas.drawCircle(center, innerRadius, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}