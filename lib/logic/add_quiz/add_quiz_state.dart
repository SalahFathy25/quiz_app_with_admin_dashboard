import 'package:equatable/equatable.dart';
import 'package:quiz_app/view/admin/add_quiz_screen.dart';

abstract class AddQuizState extends Equatable {
  const AddQuizState();

  @override
  List<Object?> get props => [];
}

class AddQuizInitial extends AddQuizState {
  final List<QuestionFormItem> questionsItems;
  final String? selectedCategoryId;

  const AddQuizInitial({required this.questionsItems, this.selectedCategoryId});

  @override
  List<Object?> get props => [questionsItems, selectedCategoryId];
}

class AddQuizLoading extends AddQuizState {
  const AddQuizLoading();
}

class AddQuizSuccess extends AddQuizState {
  const AddQuizSuccess();
}

class AddQuizError extends AddQuizState {
  final String message;

  const AddQuizError(this.message);

  @override
  List<Object> get props => [message];
}
