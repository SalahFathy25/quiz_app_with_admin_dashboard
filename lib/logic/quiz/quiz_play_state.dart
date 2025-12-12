import 'package:equatable/equatable.dart';

abstract class QuizPlayState extends Equatable {
  const QuizPlayState();

  @override
  List<Object?> get props => [];
}

class QuizPlayInitial extends QuizPlayState {}

class QuizPlayInProgress extends QuizPlayState {
  final int currentQuestionIndex;
  final Map<int, int?> selectedAnswers;
  final int remainingMinutes;
  final int remainingSeconds;
  final int totalMinutes;

  const QuizPlayInProgress({
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.remainingMinutes,
    required this.remainingSeconds,
    required this.totalMinutes,
  });

  @override
  List<Object?> get props => [
        currentQuestionIndex,
        selectedAnswers,
        remainingMinutes,
        remainingSeconds,
        totalMinutes,
      ];

  QuizPlayInProgress copyWith({
    int? currentQuestionIndex,
    Map<int, int?>? selectedAnswers,
    int? remainingMinutes,
    int? remainingSeconds,
    int? totalMinutes,
  }) {
    return QuizPlayInProgress(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalMinutes: totalMinutes ?? this.totalMinutes,
    );
  }
}

class QuizPlayCompleted extends QuizPlayState {
  final int correctAnswers;
  final int totalQuestions;
  final Map<int, int?> selectedAnswers;

  const QuizPlayCompleted({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.selectedAnswers,
  });

  @override
  List<Object?> get props => [correctAnswers, totalQuestions, selectedAnswers];
}
