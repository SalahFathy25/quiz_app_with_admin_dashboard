import 'package:equatable/equatable.dart';
import 'package:quiz_app/model/quiz.dart';

abstract class QuizByCategoryState extends Equatable {
  const QuizByCategoryState();

  @override
  List<Object> get props => [];
}

class QuizByCategoryInitial extends QuizByCategoryState {}

class QuizByCategoryLoading extends QuizByCategoryState {}

class QuizByCategoryLoaded extends QuizByCategoryState {
  final List<Quiz> quizzes;

  const QuizByCategoryLoaded(this.quizzes);

  @override
  List<Object> get props => [quizzes];
}

class QuizByCategoryError extends QuizByCategoryState {
  final String message;

  const QuizByCategoryError(this.message);

  @override
  List<Object> get props => [message];
}
