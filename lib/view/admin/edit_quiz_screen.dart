import 'package:flutter/material.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/core/theme/theme.dart';

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
            _buildQuizDetails(),
            const SizedBox(height: 16),
            _buildQuestionsSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildTitleField(),
        const SizedBox(height: 16),
        _buildTimeLimitField(),
      ],
    );
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Quiz Title',
        hintText: 'Enter Quiz title',
        prefixIcon: Icon(Icons.title, color: AppTheme.primaryColor),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a quiz title' : null,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField _buildTimeLimitField() {
    return TextFormField(
      controller: _timeLimitController,
      decoration: const InputDecoration(
        labelText: 'Time Limit (in minutes)',
        hintText: 'Enter time limit',
        prefixIcon: Icon(Icons.timer, color: AppTheme.primaryColor),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) return 'Please enter a time limit';
        final timeLimit = int.tryParse(value);
        if (timeLimit == null || timeLimit <= 0) {
          return 'Please enter a valid time limit';
        }
        return null;
      },
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          return _buildQuestionCard(entry.key, entry.value);
        }),
      ],
    );
  }

  Card _buildQuestionCard(int index, QuestionFormItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if (_questionsItems.length > 1)
                  IconButton(
                    onPressed: () => _removeQuestion(index),
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: item.questionController,
              decoration: const InputDecoration(labelText: 'Question Title'),
              validator: (v) => v!.isEmpty ? 'Please enter a question' : null,
            ),
            const SizedBox(height: 16),
            ...item.optionsControllers.asMap().entries.map((entry) {
              return _buildOptionField(item, entry.key, entry.value);
            }),
          ],
        ),
      ),
    );
  }

  Padding _buildOptionField(
    QuestionFormItem item,
    int optionIndex,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Radio<int>(
            activeColor: AppTheme.primaryColor,
            value: optionIndex,
            groupValue: item.correctOptionIndex,
            onChanged: (value) =>
                setState(() => item.correctOptionIndex = value!),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Option ${optionIndex + 1}',
              ),
              validator: (v) => v!.isEmpty ? 'Please enter an option' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateQuiz,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
                'Update Quiz',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class QuestionFormItem {
  final TextEditingController questionController;
  final List<TextEditingController> optionsControllers;
  int correctOptionIndex;

  QuestionFormItem({
    required this.questionController,
    required this.optionsControllers,
    required this.correctOptionIndex,
  });

  void dispose() {
    questionController.dispose();
    for (var controller in optionsControllers) {
      controller.dispose();
    }
  }
}
