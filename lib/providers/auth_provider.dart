import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthState {
  final bool isLoading;
  final String? user;

  const AuthState({this.isLoading = false, this.user});

  AuthState copyWith({bool? isLoading, String? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String username, String password, {required VoidCallback onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API

      if (username == 'rider' && password == 'password') {
        state = AuthState(isLoading: false, user: username);
        Fluttertoast.showToast(msg: 'Login Successful. Welcome back, $username!');
        onSuccess();
      } else {
        state = state.copyWith(isLoading: false);
        Fluttertoast.showToast(msg: 'Login Failed. Invalid credentials.', backgroundColor: Colors.red);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'An error occurred during login', backgroundColor: Colors.red);
    }
  }

  Future<void> logout() async {
    state = const AuthState();
    Fluttertoast.showToast(msg: 'You have been logged out.');
  }

  Future<void> updateProfile(String name) async {
    state = state.copyWith(user: name);
    Fluttertoast.showToast(msg: 'Your profile has been updated successfully.');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());