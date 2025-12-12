import 'package:flutter/material.dart';

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

class QuestionCard extends StatelessWidget {
  final int index;
  final QuestionFormItem item;
  final VoidCallback onRemove;
  final bool canRemove;
  final ValueChanged<int> onCorrectOptionChanged;

  const QuestionCard({
    super.key,
    required this.index,
    required this.item,
    required this.onRemove,
    required this.canRemove,
    required this.onCorrectOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                if (canRemove)
                  IconButton(
                    onPressed: onRemove,
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Radio<int>(
                      activeColor: Theme.of(context).primaryColor,
                      value: entry.key,
                      groupValue: item.correctOptionIndex,
                      onChanged: (value) => onCorrectOptionChanged(value!),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: 'Option ${entry.key + 1}',
                        ),
                        validator: (v) => v!.isEmpty ? 'Please enter an option' : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
