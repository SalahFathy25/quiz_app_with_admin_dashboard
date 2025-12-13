import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/edit_quiz/edit_quiz_state.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/view/admin/add_quiz_screen.dart';

class EditQuizCubit extends Cubit<EditQuizState> {
  final QuizService _quizService;
  final Quiz quiz;

  EditQuizCubit(this._quizService, this.quiz)
    : super(EditQuizInitial(questionsItems: []));

  void init() {
    final questionsItems = quiz.questions.map((q) {
      return QuestionFormItem(
        questionController: TextEditingController(text: q.text),
        optionsControllers: q.options
            .map((opt) => TextEditingController(text: opt))
            .toList(),
        correctOptionIndex: q.correctOptionIndex,
      );
    }).toList();
    emit(EditQuizInitial(questionsItems: questionsItems));
  }

  void addQuestion() {
    final currentState = state as EditQuizInitial;
    final newQuestion = QuestionFormItem(
      questionController: TextEditingController(),
      optionsControllers: List.generate(4, (index) => TextEditingController()),
      correctOptionIndex: 0,
    );
    emit(
      EditQuizInitial(
        questionsItems: [...currentState.questionsItems, newQuestion],
      ),
    );
  }

  void removeQuestion(int index) {
    final currentState = state as EditQuizInitial;
    if (currentState.questionsItems.length > 1) {
      currentState.questionsItems[index].dispose();
      final newItems = List.of(currentState.questionsItems)..removeAt(index);
      emit(EditQuizInitial(questionsItems: newItems));
    } else {
      emit(const EditQuizError('You must have at least one question'));
    }
  }

  Future<void> updateQuiz(
    GlobalKey<FormState> formKey,
    String title,
    String timeLimit,
  ) async {
    if (!formKey.currentState!.validate()) return;

    emit(EditQuizLoading());
    final currentState = state as EditQuizInitial;

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

      final updatedQuiz = quiz.copyWith(
        title: title,
        timeLimit: int.parse(timeLimit),
        questions: questions,
      );

      await _quizService.updateQuiz(updatedQuiz);
      emit(EditQuizSuccess());
    } catch (e) {
      emit(EditQuizError('Error updating quiz: $e'));
    }
  }
}
