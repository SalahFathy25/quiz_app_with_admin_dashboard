import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AdminStatsState {}

class AdminStatsInitial extends AdminStatsState {}

class AdminStatsLoading extends AdminStatsState {}

class AdminStatsLoaded extends AdminStatsState {
  final Map<String, dynamic> stats;
  AdminStatsLoaded(this.stats);
}

class AdminStatsError extends AdminStatsState {
  final String message;
  AdminStatsError(this.message);
}
