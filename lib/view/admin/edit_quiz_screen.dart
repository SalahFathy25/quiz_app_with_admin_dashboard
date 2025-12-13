import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/edit_quiz/edit_quiz_cubit.dart';
import 'package:quiz_app/logic/edit_quiz/edit_quiz_state.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/core/theme/theme.dart';
import '../../core/widgets/custom_button.dart';
import 'widgets/edit_quiz_details_form.dart';
import 'widgets/question_card.dart';

class EditQuizScreen extends StatelessWidget {
  final Quiz quiz;

  const EditQuizScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditQuizCubit(QuizService(), quiz)..init(),
      child: EditQuizView(quiz: quiz),
    );
  }
}

class EditQuizView extends StatefulWidget {
  final Quiz quiz;

  const EditQuizView({super.key, required this.quiz});

  @override
  State<EditQuizView> createState() => _EditQuizViewState();
}

class _EditQuizViewState extends State<EditQuizView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeLimitController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz.title);
    _timeLimitController = TextEditingController(
      text: widget.quiz.timeLimit.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditQuizCubit, EditQuizState>(
      listener: (context, state) {
        if (state is EditQuizSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'quiz_updated_successfully'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppTheme.secondaryColor,
            ),
          );
          Navigator.pop(context);
        } else if (state is EditQuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditQuizLoading;
        final questionsItems = state is EditQuizInitial
            ? state.questionsItems
            : [];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'edit_quiz'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<EditQuizCubit>().updateQuiz(
                        _formKey,
                        _titleController.text,
                        _timeLimitController.text,
                      ),
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
                    Text(
                      'questions'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<EditQuizCubit>().addQuestion(),
                      icon: const Icon(Icons.add),
                      label: Text('add_question'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...questionsItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  return QuestionCard(
                    index: index,
                    item: entry.value,
                    canRemove: questionsItems.length > 1,
                    onRemove: () =>
                        context.read<EditQuizCubit>().removeQuestion(index),
                    onCorrectOptionChanged: (value) {
                      setState(() => entry.value.correctOptionIndex = value);
                    },
                  );
                }),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'update_quiz'.tr(),
                  onPressed: isLoading
                      ? null
                      : () => context.read<EditQuizCubit>().updateQuiz(
                          _formKey,
                          _titleController.text,
                          _timeLimitController.text,
                        ),
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
