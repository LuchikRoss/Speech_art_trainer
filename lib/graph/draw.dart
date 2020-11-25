import 'package:flutter/material.dart';
import 'static/hw.dart';
import 'static/sc.dart';
import 'static/ok.dart';
import 'static/na.dart';
import 'contour/ii/uk.dart';
import 'contour/ii/lx.dart';
import 'contour/ii/li.dart';
import 'contour/ii/ve.dart';
import 'contour/ii/zr.dart';

var hw, sc, ok, na, uk, lx, li, ve, zr;

final custColor = Colors.red[900];
final defColor = Colors.red[400];

vowelCont(vowelContour, speachContour, canvas) {
  if (vowelContour=='ii') {
    var hw = hwLoad();
    var sc = scLoad();
    var ok = okLoad();
    var na = naLoad();
    var uk = ukLoad();
    var lx = lxLoad();
    var li = liLoad();
    var ve = veLoad();
    var zr = zrLoad();

    //static shadow
    drawSha(hw, canvas);
    drawSha(sc, canvas);
    drawSha(ok, canvas);
    drawSha(na, canvas);

    //contour shadow
    drawSha(uk, canvas);
    drawSha(lx, canvas);
    drawSha(li, canvas);
    drawSha(ve, canvas);
    drawSha(zr, canvas);

    //static
    drawCan(hw, canvas, defColor);
    drawCan(sc, canvas, defColor);
    drawCan(ok, canvas, defColor);
    drawCan(na, canvas, defColor);

    //contour
    drawCan(uk, canvas, defColor);
    drawCan(lx, canvas, defColor);
    drawCan(li, canvas, defColor);
    drawCan(ve, canvas, defColor);
    drawCan(zr, canvas, defColor);

    if (speachContour=='Lower Lips') { drawCanvas(li[1], canvas, custColor); }
    if (speachContour=='Upper Lips') { drawCanvas(li[0], canvas, custColor); }
  };

  if (vowelContour=='aa') {}
  if (vowelContour=='uu') {}
}

drawCan(dr, canvas, custColor) {
   for(int i=0; i<dr.length; i++) {
      drawCanvas(dr[i], canvas, custColor);
    }
}

drawSha(dr, canvas) {
   for(int i=0; i<dr.length; i++) {
      drawShad(dr[i], canvas);
    }
}

drawCanvas(dc, canvas, custColor) {

  double dcx, dcy;
    
  dcx=dc[0][0].toDouble()-10;
  dcy=dc[0][1].toDouble()-235;

  var path=Path();
  
  path.moveTo(dcx, dcy);

  dc.forEach((element) { 
    dcx=element[0].toDouble()-10;
    dcy=element[1].toDouble()-235;
    path.lineTo(dcx, dcy);
  });

  var paint=Paint()
    ..color = custColor
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  canvas.drawPath(path, paint);
}

drawShad(dc, canvas) {

  double dcx, dcy;

  var path2=Path();

  dcx=dc[0][0].toDouble()-10;
  dcy=dc[0][1].toDouble()-235;
  
  path2.moveTo(dcx+2, dcy+2);

  dc.forEach((element) { 
    dcx=element[0].toDouble()-10;
    dcy=element[1].toDouble()-235;
    path2.lineTo(dcx+2, dcy+2);
  });

  var paint2=Paint()
    ..color = Colors.grey[350]
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  canvas.drawPath(path2, paint2);
}  