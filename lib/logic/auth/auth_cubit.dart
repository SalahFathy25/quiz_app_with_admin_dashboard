import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription? _authSubscription;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  void signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void signUp(String email, String password, String role) async {
    try {
      await _authService.signUp(email, password, role);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
