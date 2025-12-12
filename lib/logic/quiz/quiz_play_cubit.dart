import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/quiz/quiz_play_state.dart';
import 'package:quiz_app/model/quiz.dart';

class QuizPlayCubit extends Cubit<QuizPlayState> {
  final Quiz quiz;
  Timer? _timer;

  QuizPlayCubit(this.quiz) : super(QuizPlayInitial());

  void startQuiz() {
    emit(QuizPlayInProgress(
      currentQuestionIndex: 0,
      selectedAnswers: {},
      remainingMinutes: quiz.timeLimit,
      remainingSeconds: 0,
      totalMinutes: quiz.timeLimit,
    ));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is QuizPlayInProgress) {
        final currentState = state as QuizPlayInProgress;
        
        if (currentState.remainingSeconds > 0) {
          emit(currentState.copyWith(
            remainingSeconds: currentState.remainingSeconds - 1,
          ));
        } else {
          if (currentState.remainingMinutes > 0) {
            emit(currentState.copyWith(
              remainingMinutes: currentState.remainingMinutes - 1,
              remainingSeconds: 59,
            ));
          } else {
            _timer?.cancel();
            completeQuiz();
          }
        }
      }
    });
  }

  void selectAnswer(int optionIndex) {
    if (state is QuizPlayInProgress) {
      final currentState = state as QuizPlayInProgress;
      
      // Only allow selecting answer if not already selected for current question
      if (currentState.selectedAnswers[currentState.currentQuestionIndex] == null) {
        final updatedAnswers = Map<int, int?>.from(currentState.selectedAnswers);
        updatedAnswers[currentState.currentQuestionIndex] = optionIndex;
        
        emit(currentState.copyWith(selectedAnswers: updatedAnswers));
      }
    }
  }

  void nextQuestion() {
    if (state is QuizPlayInProgress) {
      final currentState = state as QuizPlayInProgress;
      
      if (currentState.currentQuestionIndex < quiz.questions.length - 1) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ));
      } else {
        completeQuiz();
      }
    }
  }

  void completeQuiz() {
    _timer?.cancel();
    
    if (state is QuizPlayInProgress) {
      final currentState = state as QuizPlayInProgress;
      final correctAnswers = _calculateScore(currentState.selectedAnswers);
      
      emit(QuizPlayCompleted(
        correctAnswers: correctAnswers,
        totalQuestions: quiz.questions.length,
        selectedAnswers: currentState.selectedAnswers,
      ));
    }
  }

  int _calculateScore(Map<int, int?> selectedAnswers) {
    int correctAnswers = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      final selectedAnswer = selectedAnswers[i];
      
      if (selectedAnswer != null &&
          selectedAnswer == quiz.questions[i].correctOptionIndex) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
