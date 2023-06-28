part of ssun_chart;

num sinDeg(num degree) => sin(_degToRad(degree));

num cosDeg(num degree) => cos(_degToRad(degree));

num tanDeg(num degree) => tan(_degToRad(degree));

num _degToRad(num degree) => degree * pi / 180;