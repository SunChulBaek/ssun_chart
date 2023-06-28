part of ssun_chart;

class RadarData {
  RadarData(
      this.dataSets
      );

  final List<RadarDataSet> dataSets;
}

class RadarDataSet {
  RadarDataSet({
    required this.color,
    required this.fillColor,
    required this.lineWidth,
    required this.entries,
  });

  final Color color;
  final Color fillColor;
  final double lineWidth;
  final List<RadarEntry> entries;
}

class RadarEntry {
  RadarEntry(
      this.value,
      );

  final double value;
}