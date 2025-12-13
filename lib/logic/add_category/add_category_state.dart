import 'package:equatable/equatable.dart';

abstract class AddCategoryState extends Equatable {
  const AddCategoryState();

  @override
  List<Object> get props => [];
}

class AddCategoryInitial extends AddCategoryState {}

class AddCategoryLoading extends AddCategoryState {}

class AddCategorySuccess extends AddCategoryState {}

class AddCategoryError extends AddCategoryState {
  final String message;

  const AddCategoryError(this.message);

  @override
  List<Object> get props => [message];
}
