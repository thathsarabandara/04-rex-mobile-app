import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../widgets/premium_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 700,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.1,
                                    child: const Text(
                                      'Reset Password',
                                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.2,
                                    child: const Text(
                                      'Create a new strong password for your account.',
                                      style: TextStyle(fontSize: 16, color: Colors.white70),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: SlideFade(
                                      animation: _animController,
                                      delay: 0.05,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/reset.png",
                                          height: 350,
                                          width: 350, 
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.3,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: theme.dividerColor),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.2), 
                                            blurRadius: 30, 
                                            offset: const Offset(0, 10),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildTextField(
                                            context: context,
                                            controller: _passwordController,
                                            label: 'New Password',
                                            hint: '••••••••',
                                            icon: LucideIcons.lock,
                                            isPassword: true,
                                            obscureState: _obscurePassword,
                                            onToggleObscure: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                          _buildTextField(
                                            context: context,
                                            controller: _confirmController,
                                            label: 'Confirm Password',
                                            hint: '••••••••',
                                            icon: LucideIcons.lock,
                                            isPassword: true,
                                            obscureState: _obscureConfirm,
                                            onToggleObscure: () {
                                              setState(() {
                                                _obscureConfirm = !_obscureConfirm;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 32),
                                          BouncingCard(
                                            onTap: () => context.go('/login'),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(vertical: 18),
                                              decoration: BoxDecoration(
                                                color: primary,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primary.withValues(alpha: 0.25), 
                                                    blurRadius: 20, 
                                                    offset: const Offset(0, 8),
                                                  )
                                                ],
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Reset Password', 
                                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureState = true,
    VoidCallback? onToggleObscure,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            obscureText: isPassword && obscureState,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: hint,
              hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
              prefixIcon: Icon(icon, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureState ? LucideIcons.eyeOff : LucideIcons.eye,
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
