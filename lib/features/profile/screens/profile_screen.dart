import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/premium_widgets.dart';
import '../../../core/theme/providers/theme_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLight = theme.brightness == Brightness.light;
    final primary = theme.colorScheme.primary;
    final themeMode = ref.watch(themeModeProvider);

    String themeLabel = 'System';
    if (themeMode == ThemeMode.light) {
      themeLabel = 'Light';
    } else if (themeMode == ThemeMode.dark) {
      themeLabel = 'Dark';
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: 350,
            child: CustomPaint(painter: HeaderWavePainter(isDark: isDark)),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: isLight 
                              ? Colors.black.withValues(alpha: 0.05) 
                              : Colors.black.withValues(alpha: 0.3), 
                          blurRadius: 24, 
                          offset: const Offset(0, -8),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(0, -50),
                              child: SlideFade(
                                animation: _animController,
                                delay: 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.2),
                                            blurRadius: 16,
                                          )
                                        ],
                                      ),
                                      child: Container(
                                        width: 100, height: 100,
                                        decoration: BoxDecoration(
                                          color: theme.scaffoldBackgroundColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: theme.dividerColor, width: 1.5),
                                        ),
                                        child: Icon(Icons.person_rounded, size: 50, color: primary),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Thathsara Bandara', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900, 
                                        fontSize: 28, 
                                        color: theme.textTheme.titleLarge?.color, 
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chief Operator', 
                                      style: TextStyle(
                                        color: primary, 
                                        fontWeight: FontWeight.w700, 
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            Transform.translate(
                              offset: const Offset(0, -20),
                              child: Column(
                                children: [
                                  _buildSection(context, 'Account', 0.2, [
                                    _buildListTile(context, Icons.person_outline_rounded, 'Edit Profile', primary),
                                    _buildListTile(context, Icons.lock_outline_rounded, 'Security', Colors.orange),
                                  ]),
                                  _buildSection(context, 'Fleet Settings', 0.3, [
                                    _buildListTile(context, Icons.precision_manufacturing_outlined, 'Manage Robots', Colors.teal),
                                    _buildListTile(context, Icons.add_circle_outline_rounded, 'Pair New Device', theme.colorScheme.secondary),
                                  ]),
                                   _buildSection(context, 'App Preferences', 0.4, [
                                    _buildListTile(
                                      context, 
                                      Icons.dark_mode_outlined, 
                                      'Theme', 
                                      primary, 
                                      trailing: themeLabel,
                                      onTap: () => _showThemeSelector(context),
                                    ),
                                    _buildListTile(context, Icons.language_rounded, 'Language', primary, trailing: 'English'),
                                  ]),
                                  
                                  const SizedBox(height: 24),
                                  SlideFade(
                                    animation: _animController,
                                    delay: 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: TextButton.icon(
                                          onPressed: () => context.go('/welcome'),
                                          icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                                          label: const Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w800, fontSize: 16)),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: BorderSide(color: const Color(0xFFEF4444).withValues(alpha: 0.15)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, double delay, List<Widget> children) {
    final theme = Theme.of(context);
    return SlideFade(
      animation: _animController,
      delay: delay,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7), 
                  fontSize: 11, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor, width: 1.0),
              ),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, Color iconColor, {String? trailing, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w700, 
          fontSize: 16, 
          color: theme.textTheme.titleMedium?.color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(
              trailing, 
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color, 
                fontWeight: FontWeight.w600, 
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.dividerColor),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showThemeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.read(themeModeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(context, 'System Default', ThemeMode.system, Icons.phone_android_rounded, currentThemeMode),
                _buildThemeOption(context, 'Light Mode', ThemeMode.light, Icons.light_mode_rounded, currentThemeMode),
                _buildThemeOption(context, 'Dark Mode', ThemeMode.dark, Icons.dark_mode_rounded, currentThemeMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, ThemeMode mode, IconData icon, ThemeMode currentMode) {
    final theme = Theme.of(context);
    final isSelected = mode == currentMode;
    final primary = theme.colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(icon, color: isSelected ? primary : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primary : theme.textTheme.titleMedium?.color,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: primary) : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
