import 'package:flutter/material.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/core/theme/theme.dart';
import '../../core/widgets/custom_button.dart';
import 'widgets/edit_quiz_details_form.dart';
import 'widgets/question_card.dart';

class EditQuizScreen extends StatefulWidget {
  final Quiz quiz;

  const EditQuizScreen({super.key, required this.quiz});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quizService = QuizService();
  late TextEditingController _titleController;
  late TextEditingController _timeLimitController;
  bool _isLoading = false;
  late List<QuestionFormItem> _questionsItems;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeLimitController.dispose();
    for (var item in _questionsItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _initData() {
    _titleController = TextEditingController(text: widget.quiz.title);
    _timeLimitController = TextEditingController(
      text: widget.quiz.timeLimit.toString(),
    );
    _questionsItems = widget.quiz.questions.map((q) {
      return QuestionFormItem(
        questionController: TextEditingController(text: q.text),
        optionsControllers: q.options
            .map((opt) => TextEditingController(text: opt))
            .toList(),
        correctOptionIndex: q.correctOptionIndex,
      );
    }).toList();
  }

  void _addQuestion() {
    setState(() {
      _questionsItems.add(
        QuestionFormItem(
          questionController: TextEditingController(),
          optionsControllers: List.generate(
            4,
            (index) => TextEditingController(),
          ),
          correctOptionIndex: 0,
        ),
      );
    });
  }

  void _removeQuestion(int index) {
    if (_questionsItems.length > 1) {
      setState(() {
        _questionsItems[index].dispose();
        _questionsItems.removeAt(index);
      });
    } else {
      _showSnackbar('You must have at least one question', isError: true);
    }
  }

  Future<void> _updateQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final questions = _questionsItems
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

      final updatedQuiz = widget.quiz.copyWith(
        title: _titleController.text.trim(),
        timeLimit: int.parse(_timeLimitController.text.trim()),
        questions: questions,
      );

      await _quizService.updateQuiz(updatedQuiz);
      _showSnackbar('Quiz updated successfully');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Error updating quiz: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: isError ? Colors.redAccent : AppTheme.secondaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _updateQuiz,
            icon: const Icon(Icons.save, color: AppTheme.primaryColor),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            EditQuizDetailsForm(
              titleController: _titleController,
              timeLimitController: _timeLimitController,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Questions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._questionsItems.asMap().entries.map((entry) {
              final index = entry.key;
              return QuestionCard(
                index: index,
                item: entry.value,
                canRemove: _questionsItems.length > 1,
                onRemove: () => _removeQuestion(index),
                onCorrectOptionChanged: (value) {
                  setState(() => entry.value.correctOptionIndex = value);
                },
              );
            }),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Update Quiz',
              onPressed: _isLoading ? null : _updateQuiz,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
