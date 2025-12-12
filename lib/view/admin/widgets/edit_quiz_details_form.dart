import 'package:flutter/material.dart';

class EditQuizDetailsForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController timeLimitController;

  const EditQuizDetailsForm({
    super.key,
    required this.titleController,
    required this.timeLimitController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Quiz Title',
            hintText: 'Enter Quiz title',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter a quiz title' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: timeLimitController,
          decoration: const InputDecoration(
            labelText: 'Time Limit (in minutes)',
            hintText: 'Enter time limit',
            prefixIcon: Icon(Icons.timer),
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
        ),
      ],
    );
  }
}
