part of ssun_chart;

num sinDeg(num degree) => sin(degToRad(degree));

num cosDeg(num degree) => cos(degToRad(degree));

num tanDeg(num degree) => tan(degToRad(degree));

num degToRad(num degree) => degree * pi / 180;

Offset modifiedOffset(Size size, Offset offset, double width, double height) {
  double dx = offset.dx - width / 2;
  double dy = offset.dy - height / 2;

  if (dx < 0) {
    dx = 0;
  } else if (dx + width > size.width) {
    dx = size.width - width;
  }

  if (dy < 0) {
    dy = 0;
  } else if (dy + height > size.height) {
    dy = size.height - height;
  }

  return Offset(dx, dy);
}