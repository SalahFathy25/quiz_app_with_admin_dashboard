import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/add_category/add_category_cubit.dart';
import 'package:quiz_app/logic/add_category/add_category_state.dart';
import 'package:quiz_app/services/category_service.dart';
import '../../core/widgets/custom_button.dart';
import '../../model/category.dart';
import 'widgets/category_form_fields.dart';

class AddCategoryScreen extends StatelessWidget {
  final Category? category;

  const AddCategoryScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryCubit(CategoryService(), category),
      child: AddCategoryView(category: category),
    );
  }
}

class AddCategoryView extends StatefulWidget {
  final Category? category;

  const AddCategoryView({super.key, this.category});

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController = TextEditingController(
      text: widget.category?.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('discard_changes'.tr()),
              content: Text(
                'are_you_sure_you_want_to_discard_your_changes'.tr(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'delete'.tr(),
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category == null
                ? 'add_category'.tr()
                : 'edit_category'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AddCategoryCubit, AddCategoryState>(
          listener: (context, state) {
            if (state is AddCategorySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.category == null
                        ? 'category_added_successfully'.tr()
                        : 'category_updated_successfully'.tr(),
                  ),
                ),
              );
              Navigator.pop(context, true);
            } else if (state is AddCategoryError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AddCategoryLoading;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryFormFields(
                        nameController: _nameController,
                        descriptionController: _descriptionController,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: widget.category == null
                            ? 'add_category'.tr()
                            : 'update_category'.tr(),
                        onPressed: isLoading
                            ? null
                            : () =>
                                  context.read<AddCategoryCubit>().saveCategory(
                                    _formKey,
                                    _nameController.text,
                                    _descriptionController.text,
                                  ),
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
