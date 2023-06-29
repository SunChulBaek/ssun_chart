part of ssun_chart;

num sinDeg(num degree) => sin(degToRad(degree));

num cosDeg(num degree) => cos(degToRad(degree));

num tanDeg(num degree) => tan(degToRad(degree));

num degToRad(num degree) => degree * pi / 180;