import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../domain/model/intraday_info.dart';

class StockChart extends StatelessWidget {
  // saju, 주역 등의 데이터 받아와서 차트에 뿌려준다
  final List<IntradayInfo> infos;
  final Color graphColor;
  final Color textColor;

  const StockChart({
    Key? key,
    this.infos = const [],
    required this.graphColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: CustomPaint(
        painter: ChartPainter(infos, graphColor, textColor),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<IntradayInfo> infos;
  final Color graphColor;
  final Color textColor;

  // 가장 높은 가격 반올림
  late int upperValue =
  infos.map((e) => e.close)
      .fold<double>(0.0, max).ceil();
  // 가장 낮은 가격 소수점 이하 버림
  late int lowerValue =
  infos.map((e) => e.close)
      .reduce(min).toInt();

  final spacing = 50.0;

  // Paint는 생성자에 넣어두고 사용하는 것이 성능에 유리함
  late Paint strokePaint;

  ChartPainter(this.infos, this.graphColor, this.textColor){
    strokePaint = Paint()
      ..color = graphColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 세로 텍스트 .. 5등분한 각 구간 정의하여 낮은 가격에서 추가한다
    final priceStep = (upperValue - lowerValue) / 5.0;
    for (var i = 0; i < 5; i++) {
      // tp: 위치 지정값
      final tp = TextPainter(
        text: TextSpan(
          text: '${(lowerValue + priceStep * i).round()}',
          style: TextStyle(fontSize: 12, color: textColor),
        ),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(10, size.height - spacing - i * (size.height / 5.0)));
    }
    // 가로 텍스트
    final spacePerHour = (size.width - spacing) / infos.length;
    for(var i = 0; i < infos.length; i += 12) {
      final hour = infos[i].date.hour;

      final tp = TextPainter(
        text: TextSpan(
          text: '$hour',
          style: TextStyle(fontSize: 12, color: textColor),
        ),
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(i * spacePerHour + spacing, size.height + 20));
    }
    // graph 차트 그리기 위치 정보 계산
    var lastX = 0.0;
    final strokePath = Path();
    for(var i = 0; i < infos.length; i++){
      final info = infos[i];
      var nextIndex = i + 1;
      if (i + 1 > infos.length - 1) nextIndex = infos.length - 1;
      final nextInfo = infos[nextIndex];
      final leftRatio = (info.close - lowerValue) / (upperValue - lowerValue);
      final rightRatio = (nextInfo.close - lowerValue) / (upperValue - lowerValue);
      // 좌표
      final x1 = spacing + i * spacePerHour;
      final y1 = size.height - (leftRatio * size.height).toDouble();
      final x2 = spacing + (i + 1) * spacePerHour;
      final y2 = size.height - (rightRatio * size.height).toDouble();

      if (i == 0) {
        strokePath.moveTo(x1, y1);
      }
      lastX = (x1 + x2) / 2.0;
      strokePath.quadraticBezierTo(x1, y1, lastX, (y1 + y2) / 2.0);
    }
    // graph 그라데이션
    final fillPath = Path.from(strokePath)
      ..lineTo(lastX, size.height - spacing)
      ..lineTo(spacing, size.height - spacing)
      ..close();

    final fillPaint = Paint()
      ..color = graphColor
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, size.height -spacing),
          [
            graphColor.withOpacity(0.3),
            Colors.transparent,
          ]);

    // graph 차트 그리기
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(strokePath, strokePaint);

  }

  @override
  // bool shouldRepaint(covariant CustomPainter oldDelegate) {
  bool shouldRepaint(ChartPainter oldDelegate) {
    // 데이터가 바뀔때만 다시 그린다. true하면 실행될 때마다 그림
    return oldDelegate.infos != infos;
  }
}
