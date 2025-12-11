import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../model/question.dart';
import '../../model/quiz.dart';
import '../../services/category_service.dart';
import '../../services/quiz_service.dart';

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
  final _categoryService = CategoryService();
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
            _buildQuizDetails(context),
            const SizedBox(height: 16),
            _buildQuestionsSection(context),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz Details',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildTitleField(context),
        const SizedBox(height: 20),
        if (widget.categoryId == null) _buildCategoryDropdown(context),
        const SizedBox(height: 16),
        _buildTimeLimitField(context),
      ],
    );
  }

  TextFormField _buildTitleField(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Quiz Title',
        hintText: 'Enter Quiz title',
        prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a quiz title' : null,
      textInputAction: TextInputAction.next,
    );
  }

  StreamBuilder<List<Category>> _buildCategoryDropdown(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: _categoryService.getCategoriesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Category',
            hintText: 'Select category',
            prefixIcon: Icon(
              Icons.category,
              color: Theme.of(context).primaryColor,
            ),
          ),
          items: categories
              .map(
                (category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedCategoryId = value),
          validator: (value) =>
              value == null ? 'Please select a category' : null,
        );
      },
    );
  }

  TextFormField _buildTimeLimitField(BuildContext context) {
    return TextFormField(
      controller: _timeLimitController,
      decoration: InputDecoration(
        labelText: 'Time Limit (in minutes)',
        hintText: 'Enter time limit',
        prefixIcon: Icon(Icons.timer, color: Theme.of(context).primaryColor),
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

  Widget _buildQuestionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          return _buildQuestionCard(index, entry.value, context);
        }),
      ],
    );
  }

  Card _buildQuestionCard(
    int index,
    QuestionFormItem item,
    BuildContext context,
  ) {
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
              return _buildOptionField(item, entry.key, entry.value, context);
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
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Radio<int>(
            activeColor: Theme.of(context).primaryColor,
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
