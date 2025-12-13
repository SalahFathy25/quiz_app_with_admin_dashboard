import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/add_quiz/add_quiz_cubit.dart';
import 'package:quiz_app/logic/add_quiz/add_quiz_state.dart';
import 'package:quiz_app/services/quiz_service.dart';

import 'widgets/quiz_details_form.dart';
import 'widgets/question_card.dart';

export 'widgets/question_card.dart' show QuestionFormItem;

class AddQuizScreen extends StatelessWidget {
  final String? categoryName;
  final String? categoryId;

  const AddQuizScreen({super.key, this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddQuizCubit(QuizService(), categoryId),
      child: AddQuizView(categoryName: categoryName, categoryId: categoryId),
    );
  }
}

class AddQuizView extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;

  const AddQuizView({super.key, this.categoryName, this.categoryId});

  @override
  State<AddQuizView> createState() => _AddQuizViewState();
}

class _AddQuizViewState extends State<AddQuizView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddQuizCubit>().addQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddQuizCubit, AddQuizState>(
      listener: (context, state) {
        if (state is AddQuizSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'quiz_added_successfully'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
          Navigator.pop(context);
        } else if (state is AddQuizError) {
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
        final isLoading = state is AddQuizLoading;
        final questionsItems = state is AddQuizInitial
            ? state.questionsItems
            : [];
        final selectedCategoryId = state is AddQuizInitial
            ? state.selectedCategoryId
            : null;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.categoryName != null
                  ? 'add_quiz_to'.tr(args: [widget.categoryName!])
                  : 'add_quiz'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<AddQuizCubit>().saveQuiz(
                        _formKey,
                        _titleController.text,
                        _timeLimitController.text,
                      ),
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
                  selectedCategoryId: selectedCategoryId,
                  onCategoryChanged: (value) =>
                      context.read<AddQuizCubit>().onCategoryChanged(value),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'questions'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<AddQuizCubit>().addQuestion(),
                      icon: const Icon(Icons.add),
                      label: Text('add_question'.tr()),
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
                        context.read<AddQuizCubit>().removeQuestion(index),
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
                    onPressed: isLoading
                        ? null
                        : () => context.read<AddQuizCubit>().saveQuiz(
                            _formKey,
                            _titleController.text,
                            _timeLimitController.text,
                          ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'save_quiz'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
