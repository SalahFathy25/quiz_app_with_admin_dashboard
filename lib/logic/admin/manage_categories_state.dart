import 'package:equatable/equatable.dart';
import 'package:quiz_app/model/category.dart';

abstract class ManageCategoriesState extends Equatable {
  const ManageCategoriesState();

  @override
  List<Object> get props => [];
}

class ManageCategoriesInitial extends ManageCategoriesState {}

class ManageCategoriesLoading extends ManageCategoriesState {}

class ManageCategoriesLoaded extends ManageCategoriesState {
  final List<Category> categories;

  const ManageCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ManageCategoriesError extends ManageCategoriesState {
  final String message;

  const ManageCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}
