import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/theme/theme.dart';

import '../../model/question.dart';
import '../../model/quiz.dart';
import 'quiz_result_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentQuestionIndex = 0;
  Map<int, int?> _selectedAnswers = {};
  int _totalMinutes = 0;
  int _remainingMinutes = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _totalMinutes = widget.quiz.timeLimit;
    _remainingMinutes = _totalMinutes;
    _remainingSeconds = 0;

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          if (_remainingMinutes > 0) {
            _remainingMinutes--;
            _remainingSeconds = 59;
          } else {
            _timer?.cancel();
            _completeQuiz();
          }
        }
      });
    });
  }

  void _selectAnswer(int optionIndex) {
    if (_selectedAnswers[_currentQuestionIndex] == null) {
      setState(() {
        _selectedAnswers[_currentQuestionIndex] = optionIndex;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    _timer?.cancel();
    int correctAnswers = _calculateScore();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          totalQuestions: widget.quiz.questions.length,
          correctAnswers: correctAnswers,
          selectedAnswers: _selectedAnswers,
        ),
      ),
    );
  }

  int _calculateScore() {
    int correctAnswers = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final selectedAnswer = _selectedAnswers[i];

      if (selectedAnswer != null &&
          selectedAnswer == widget.quiz.questions[i].correctOptionIndex) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  Color _getTimerColor() {
    double timerProgress =
        1 -
        ((_remainingMinutes * 60 + _remainingSeconds) / (_totalMinutes * 60));
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
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(12.r),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 55.w,
                            width: 55.w,
                            child: CircularProgressIndicator(
                              value:
                                  ((_remainingMinutes * 60 +
                                      _remainingSeconds) /
                                  (_totalMinutes * 60)),
                              strokeWidth: 5.w,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getTimerColor(),
                              ),
                            ),
                          ),
                          Text(
                            '$_remainingMinutes:${_remainingSeconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: _getTimerColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end:
                          (_currentQuestionIndex + 1) /
                          widget.quiz.questions.length,
                    ),
                    duration: Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10.r),
                          right: Radius.circular(10.r),
                        ),
                        value: value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                        minHeight: 6.h,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.quiz.questions.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final question = widget.quiz.questions[index];
                  return _buildQuestionCard(question, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Container(
          margin: EdgeInsets.all(16.r),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${"question".tr()} ${index + 1}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).textTheme.bodyLarge?.backgroundColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                question.text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.backgroundColor,
                ),
              ),
              SizedBox(height: 24.h),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final _isSelected = _selectedAnswers[index] == optionIndex;
                final _isCorrect =
                    _selectedAnswers[index] == question.correctOptionIndex;

                return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _isSelected
                              ? _isCorrect
                                    ? AppTheme.secondaryColor.withAlpha(10)
                                    : Colors.redAccent.withAlpha(10)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isSelected
                                ? _isCorrect
                                      ? AppTheme.secondaryColor
                                      : Colors.redAccent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: ListTile(
                          onTap: _selectedAnswers[index] == null
                              ? () => _selectAnswer(optionIndex)
                              : null,
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: _isSelected
                                  ? _isCorrect
                                        ? AppTheme.secondaryColor
                                        : Colors.redAccent
                                  : _selectedAnswers[index] != null
                                  ? Colors.grey.shade500
                                  : AppTheme.lightTextPrimaryColor,
                            ),
                          ),
                          trailing: _isSelected
                              ? _isCorrect
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.secondaryColor,
                                      )
                                    : Icon(Icons.close, color: Colors.redAccent)
                              : null,
                        ),
                      ),
                    )
                    .animate(delay: Duration(milliseconds: 300))
                    .slideX(
                      begin: 0.5,
                      end: 0,
                      duration: Duration(milliseconds: 300),
                    )
                    .fadeIn();
              }),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () {
                    _selectedAnswers[index] != null ? _nextQuestion() : null;
                  },
                  child: Text(
                    index == widget.quiz.questions.length - 1
                        ? 'finish_quiz'.tr()
                        : 'next_question'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 500))
        .slideY(begin: 0.1, end: 0);
  }
}
