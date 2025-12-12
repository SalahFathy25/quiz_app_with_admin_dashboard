import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizTimer extends StatelessWidget {
  final int remainingMinutes;
  final int remainingSeconds;
  final int totalMinutes;

  const QuizTimer({
    super.key,
    required this.remainingMinutes,
    required this.remainingSeconds,
    required this.totalMinutes,
  });

  Color _getTimerColor() {
    double timerProgress =
        1 - ((remainingMinutes * 60 + remainingSeconds) / (totalMinutes * 60));
    if (timerProgress < 0.4) {
      return Colors.green;
    } else if (timerProgress < 0.6) {
      return Colors.orange;
    } else if (timerProgress < 0.8) {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 55.w,
          width: 55.w,
          child: CircularProgressIndicator(
            value: ((remainingMinutes * 60 + remainingSeconds) /
                (totalMinutes * 60)),
            strokeWidth: 5.w,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
          ),
        ),
        Text(
          '$remainingMinutes:${remainingSeconds.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: _getTimerColor(),
          ),
        ),
      ],
    );
  }
}
