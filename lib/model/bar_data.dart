part of ssun_chart;

class BarData {
  BarData(
    this.dataSets
  );

  final List<BarDataSet> dataSets;
}

class BarDataSet {
  BarDataSet({
    required this.color,
    required this.entries,
  });

  final Color color;
  final List<BarEntry> entries;
}

class BarEntry {
  BarEntry(
    this.value,
  );

  final double value;
}