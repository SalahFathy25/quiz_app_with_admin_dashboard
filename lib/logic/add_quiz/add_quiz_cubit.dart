import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/add_quiz/add_quiz_state.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/services/quiz_service.dart';

import '../../view/admin/widgets/question_card.dart';

class AddQuizCubit extends Cubit<AddQuizState> {
  final QuizService _quizService;
  final String? categoryId;

  AddQuizCubit(this._quizService, this.categoryId)
    : super(AddQuizInitial(questionsItems: [], selectedCategoryId: categoryId));

  void addQuestion() {
    final currentState = state as AddQuizInitial;
    final newQuestion = QuestionFormItem(
      questionController: TextEditingController(),
      optionsControllers: List.generate(4, (index) => TextEditingController()),
      correctOptionIndex: 0,
    );
    emit(
      AddQuizInitial(
        questionsItems: [...currentState.questionsItems, newQuestion],
        selectedCategoryId: currentState.selectedCategoryId,
      ),
    );
  }

  void removeQuestion(int index) {
    final currentState = state as AddQuizInitial;
    currentState.questionsItems[index].dispose();
    final newItems = List.of(currentState.questionsItems)..removeAt(index);
    emit(
      AddQuizInitial(
        questionsItems: newItems,
        selectedCategoryId: currentState.selectedCategoryId,
      ),
    );
  }

  void onCategoryChanged(String? value) {
    final currentState = state as AddQuizInitial;
    emit(
      AddQuizInitial(
        questionsItems: currentState.questionsItems,
        selectedCategoryId: value,
      ),
    );
  }

  Future<void> saveQuiz(
    GlobalKey<FormState> formKey,
    String title,
    String timeLimit,
  ) async {
    if (!formKey.currentState!.validate()) return;
    final currentState = state as AddQuizInitial;
    if (currentState.selectedCategoryId == null) {
      emit(const AddQuizError('Please select a category'));
      return;
    }

    emit(const AddQuizLoading());

    try {
      final questions = currentState.questionsItems
          .map(
            (item) => Question(
              text: item.questionController.text.trim(),
              correctOptionIndex: item.correctOptionIndex,
              options: item.optionsControllers
                  .map((c) => c.text.trim())
                  .toList(),
            ),
          )
          .toList();

      final newQuiz = Quiz(
        id: '',
        title: title,
        categoryId: currentState.selectedCategoryId!,
        timeLimit: int.parse(timeLimit),
        questions: questions,
        createdAt: DateTime.now(),
      );

      await _quizService.addQuiz(newQuiz);
      emit(const AddQuizSuccess());
    } catch (e) {
      emit(AddQuizError('Error saving quiz: $e'));
    }
  }
}
