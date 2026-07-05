import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/reset_password_screen.dart';
import 'features/dashboard/screens/main_shell.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/robots/screens/robots_screen.dart';
import 'features/control/screens/control_center_screen.dart';
import 'features/control/screens/teleop_screen.dart';
import 'features/connection/screens/connection_screen.dart';
import 'features/vision/screens/vision_center_screen.dart';
import 'features/assistant/screens/assistant_screen.dart';
import 'features/automation/screens/automation_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/change_password_screen.dart';
import 'features/profile/screens/sessions_screen.dart';
import 'features/profile/screens/activity_log_screen.dart';
import 'widgets/premium_widgets.dart';
import 'core/theme/providers/theme_provider.dart';
import 'features/connection/providers/bluetooth_provider.dart';

void main() {
  runApp(const ProviderScope(child: GrabberApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpScreen(email: state.extra as String?),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/robots',
            builder: (context, state) => const RobotsScreen(),
          ),
          GoRoute(
            path: '/control',
            builder: (context, state) => const ControlCenterScreen(),
          ),
          GoRoute(
            path: '/vision',
            builder: (context, state) => const VisionCenterScreen(),
          ),
          GoRoute(
            path: '/assistant',
            builder: (context, state) => const AssistantScreen(),
          ),
          GoRoute(
            path: '/automation',
            builder: (context, state) => const AutomationScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/teleop',
        builder: (context, state) => const TeleopScreen(),
      ),
      GoRoute(
        path: '/connection',
        builder: (context, state) => const ConnectionScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/sessions',
        builder: (context, state) => const SessionsScreen(),
      ),
      GoRoute(
        path: '/activity-log',
        builder: (context, state) => const ActivityLogScreen(),
      ),
    ],
  );
});

class GrabberApp extends ConsumerWidget {
  const GrabberApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'REX-47',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animController.forward();

    final timerFuture = Future.delayed(const Duration(seconds: 3));

    Future.microtask(() async {
      await ref.read(bluetoothProvider.notifier).requestPermissions();
      await timerFuture;

      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: HeaderWavePainter()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideFade(
                  animation: _animController,
                  delay: 0.3,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                    ),
                    child: Image.asset("assets/splash.png",
                      fit: BoxFit.contain,
                      height: 300,
                      width: 300,
                      ),
                  ),
                ),
                const SizedBox(height: 32),
                SlideFade(
                  animation: _animController,
                  delay: 0.3,
                  child: const Text('REX-47', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                SlideFade(
                  animation: _animController,
                  delay: 0.5,
                  child: Text('Control. Automate. Innovate.', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
