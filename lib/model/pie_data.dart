part of ssun_chart;

class PieData {
  PieData(
    this.dataSets
  );

  final List<PieDataSet> dataSets;
}

class PieDataSet {
  PieDataSet({
    required this.colors,
    required this.entries,
  });

  final List<Color> colors;
  final List<PieEntry> entries;
}

class PieEntry {
  PieEntry(
    this.value,
  );

  final double value;
}