import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final List<dynamic> sessions;
  final List<dynamic> activityLog;

  ProfileState({
    this.isLoading = false,
    this.error,
    this.sessions = const [],
    this.activityLog = const [],
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? sessions,
    List<dynamic>? activityLog,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can be set to null
      sessions: sessions ?? this.sessions,
      activityLog: activityLog ?? this.activityLog,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.post('/auth/password/change', body: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });

      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Failed to change password';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
    return false;
  }

  Future<void> fetchSessions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.get('/auth/sessions');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, sessions: data['sessions'] ?? []);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch sessions';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
  }

  Future<bool> revokeSession(int sessionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.delete('/auth/sessions/$sessionId');
      if (response.statusCode == 200) {
        // Refresh sessions
        await fetchSessions();
        return true;
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Failed to revoke session';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
    return false;
  }

  Future<void> fetchActivityLog() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiClient.get('/auth/history');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, activityLog: data['history'] ?? []);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch activity log';
        state = state.copyWith(isLoading: false, error: error);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error occurred');
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
