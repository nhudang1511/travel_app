import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(120.498,678);
    path_0.lineTo(0,678);
    path_0.lineTo(0,389.016);
    path_0.cubicTo(0,389.016,5.63678,311.081,18.0254,254.509);
    path_0.cubicTo(30.4141,197.937,51.5672,122.619,51.5672,122.619);
    path_0.cubicTo(51.5672,122.619,89.3428,3.07263,120.498,0);

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0,paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(119.502,678);
    path_1.lineTo(240,678);
    path_1.lineTo(240,389.016);
    path_1.cubicTo(240,389.016,234.363,311.081,221.975,254.509);
    path_1.cubicTo(209.586,197.937,188.433,122.619,188.433,122.619);
    path_1.cubicTo(188.433,122.619,150.657,3.07263,119.502,0);

    Paint paint1Fill = Paint()..style=PaintingStyle.fill;
    paint1Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1,paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(44,215);
    path_2.lineTo(65.5526,205.832);
    path_2.lineTo(74,178);
    path_2.lineTo(54.734,178);
    path_2.lineTo(44,215);
    path_2.close();

    Paint paint2Fill = Paint()..style=PaintingStyle.fill;
    paint2Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_2,paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(55,175);
    path_3.lineTo(75.8738,175);
    path_3.lineTo(84,165.671);
    path_3.lineTo(74.109,146);
    path_3.lineTo(55,175);
    path_3.close();

    Paint paint3Fill = Paint()..style=PaintingStyle.fill;
    paint3Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_3,paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(77,143.053);
    path_4.lineTo(85.9351,164);
    path_4.lineTo(119,143.053);
    path_4.lineTo(119,115);
    path_4.lineTo(77,143.053);
    path_4.close();

    Paint paint4Fill = Paint()..style=PaintingStyle.fill;
    paint4Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_4,paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(197,215);
    path_5.lineTo(175.447,205.832);
    path_5.lineTo(167,178);
    path_5.lineTo(186.266,178);
    path_5.lineTo(197,215);
    path_5.close();

    Paint paint5Fill = Paint()..style=PaintingStyle.fill;
    paint5Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_5,paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(186,175);
    path_6.lineTo(165.126,175);
    path_6.lineTo(157,165.671);
    path_6.lineTo(166.891,146);
    path_6.lineTo(186,175);
    path_6.close();

    Paint paint6Fill = Paint()..style=PaintingStyle.fill;
    paint6Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_6,paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(164,143.053);
    path_7.lineTo(155.065,164);
    path_7.lineTo(122,143.053);
    path_7.lineTo(122,115);
    path_7.lineTo(164,143.053);
    path_7.close();

    Paint paint7Fill = Paint()..style=PaintingStyle.fill;
    paint7Fill.color = const Color(0xffE0DDF5).withOpacity(1.0);
    canvas.drawPath(path_7,paint7Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}