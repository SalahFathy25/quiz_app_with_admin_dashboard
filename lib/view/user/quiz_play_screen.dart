import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/quiz/quiz_play_cubit.dart';
import 'package:quiz_app/logic/quiz/quiz_play_state.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/view/user/quiz_result_screen.dart';
import 'package:quiz_app/view/user/widgets/quiz_header.dart';
import 'package:quiz_app/view/user/widgets/quiz_question_card.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<QuizPlayCubit>().startQuiz();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizPlayCubit, QuizPlayState>(
      listener: (context, state) {
        if (state is QuizPlayCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultScreen(
                quiz: widget.quiz,
                totalQuestions: state.totalQuestions,
                correctAnswers: state.correctAnswers,
                selectedAnswers: state.selectedAnswers,
              ),
            ),
          );
        } else if (state is QuizPlayInProgress) {
          // Animate to the current question when state changes
          if (_pageController.hasClients &&
              _pageController.page?.round() != state.currentQuestionIndex) {
            _pageController.animateToPage(
              state.currentQuestionIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: BlocBuilder<QuizPlayCubit, QuizPlayState>(
            builder: (context, state) {
              if (state is! QuizPlayInProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuizHeader(quiz: widget.quiz),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.quiz.questions.length,
                      itemBuilder: (context, index) {
                        final question = widget.quiz.questions[index];
                        return QuizQuestionCard(
                          question: question,
                          index: index,
                          selectedAnswers: state.selectedAnswers,
                          totalQuestions: widget.quiz.questions.length,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
