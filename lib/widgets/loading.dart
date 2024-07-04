import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;
  final Color color;

  const Loading({
    super.key,
    this.message = 'Loading...',
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ],
      ),
    );
  }
}
