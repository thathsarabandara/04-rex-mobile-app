import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final Map<String, dynamic>? user;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final token = await apiClient.getAccessToken();
    if (token != null) {
      try {
        final response = await apiClient.get('/auth/profile');
        if (response.statusCode == 200) {
          state = state.copyWith(
            isAuthenticated: true,
            user: jsonDecode(response.body),
            isLoading: false,
          );
          return;
        } else {
          await apiClient.clearTokens();
        }
      } catch (e) {
        // Network error, might still be authenticated offline but for now we'll just show error
      }
    }
    state = state.copyWith(isLoading: false, isAuthenticated: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.post('/auth/login', body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['access_token'] != null) {
          await apiClient.saveTokens(data['access_token'], data['refresh_token']);
          await checkAuthStatus(); // Fetch profile
          return true;
        }
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
    return false;
  }

  Future<bool> registerInitiate(String firstName, String lastName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.post('/auth/register/initiate', body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
         final data = jsonDecode(response.body);
         if (data['temp_token'] != null) {
           await apiClient.saveTokens(data['temp_token'], 'dummy'); // temporarily save temp token as access token
         }
         state = state.copyWith(isLoading: false);
         return true; // OTP sent
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
    return false;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tempToken = await apiClient.getAccessToken(); // we saved it here
      final response = await apiClient.post('/auth/register/verify', body: {
        'email': email,
        'otp': otp,
        'temp_token': tempToken,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['access_token'] != null) {
          await apiClient.saveTokens(data['access_token'], data['refresh_token']);
          await checkAuthStatus();
          return true;
        }
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Verification failed';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
    return false;
  }

  Future<void> logout() async {
    await apiClient.clearTokens();
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
