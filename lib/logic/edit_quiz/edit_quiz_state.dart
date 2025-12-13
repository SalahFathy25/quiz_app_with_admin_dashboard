import 'package:equatable/equatable.dart';
import 'package:quiz_app/view/admin/add_quiz_screen.dart';

abstract class EditQuizState extends Equatable {
  const EditQuizState();

  @override
  List<Object> get props => [];
}

class EditQuizInitial extends EditQuizState {
  final List<QuestionFormItem> questionsItems;

  const EditQuizInitial({required this.questionsItems});

  @override
  List<Object> get props => [questionsItems];
}

class EditQuizLoading extends EditQuizState {}

class EditQuizSuccess extends EditQuizState {}

class EditQuizError extends EditQuizState {
  final String message;

  const EditQuizError(this.message);

  @override
  List<Object> get props => [message];
}
