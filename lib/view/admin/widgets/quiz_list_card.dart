import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz.dart';

class QuizListCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final void Function(String) onAction;

  const QuizListCard({
    super.key,
    required this.quiz,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.quiz_rounded, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          quiz.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(Icons.question_answer_outlined, size: 16),
              const SizedBox(width: 4.0),
              Text("${quiz.questions.length} Questions"),
              const SizedBox(width: 16.0),
              const Icon(Icons.timer_outlined, size: 16.0),
              const SizedBox(width: 4.0),
              Text("${quiz.timeLimit} mins"),
            ],
          ),
        ),
        trailing: PopupMenuButton(
          onSelected: onAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                title: const Text('Edit'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete, color: Colors.redAccent),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
