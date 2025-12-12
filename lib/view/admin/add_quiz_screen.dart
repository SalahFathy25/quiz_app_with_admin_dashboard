import 'package:flutter/material.dart';

import '../../model/question.dart';
import '../../model/quiz.dart';
import '../../services/quiz_service.dart';
import 'widgets/quiz_details_form.dart';
import 'widgets/question_card.dart';

export 'widgets/question_card.dart' show QuestionFormItem;

class AddQuizScreen extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;

  const AddQuizScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final _quizService = QuizService();
  bool _isLoading = false;
  String? _selectedCategoryId;
  final List<QuestionFormItem> _questionsItems = [];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _addQuestion();
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
    setState(() {
      _questionsItems[index].dispose();
      _questionsItems.removeAt(index);
    });
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      _showSnackbar('Please select a category', isError: true);
      return;
    }

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

      final newQuiz = Quiz(
        id: '',
        // Firestore will generate this
        title: _titleController.text.trim(),
        categoryId: _selectedCategoryId!,
        timeLimit: int.parse(_timeLimitController.text.trim()),
        questions: questions,
        createdAt: DateTime.now(),
      );

      await _quizService.addQuiz(newQuiz);
      _showSnackbar('Quiz added successfully');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Error saving quiz: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: isError
              ? Colors.redAccent
              : Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName != null
              ? 'Add ${widget.categoryName} Quiz'
              : 'Add Quiz',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveQuiz,
            icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            QuizDetailsForm(
              titleController: _titleController,
              timeLimitController: _timeLimitController,
              categoryId: widget.categoryId,
              selectedCategoryId: _selectedCategoryId,
              onCategoryChanged: (value) => setState(() => _selectedCategoryId = value),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
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
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveQuiz,
                child: _isLoading
                    ? const SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Quiz',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
