import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;
  final Color color;

  Loading({
    super.key,
    this.message = 'Loading...',
    this.color = Colors.purpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    return CircularSeekBar(
      width: double.infinity,
      height: 250,
      progress: 100,
      barWidth: 8,
      startAngle: 45,
      sweepAngle: 270,
      strokeCap: StrokeCap.round,
      progressGradientColors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple
      ],
      innerThumbRadius: 5,
      innerThumbStrokeWidth: 3,
      innerThumbColor: Colors.white,
      outerThumbRadius: 5,
      outerThumbStrokeWidth: 10,
      outerThumbColor: Colors.blueAccent,
      dashWidth: 1,
      dashGap: 2,
      animation: true,
      curves: Curves.bounceOut,
      valueNotifier: ValueNotifier(0),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
