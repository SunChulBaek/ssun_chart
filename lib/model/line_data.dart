part of ssun_chart;

class LineData {
  LineData(
    this.dataSets
  );

  final List<LineDataSet> dataSets;
}

class LineDataSet {
  LineDataSet({
    required this.color,
    required this.lineWidth,
    required this.entries,
  });

  final Color color;
  final double lineWidth;
  final List<LineEntry> entries;
}

class LineEntry {
  LineEntry(
    this.value,
  );

  final double value;
}