import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';
import 'auth_screen.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  final UserDataService userService;
  const SplashScreen({super.key, required this.userService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final nextScreen = widget.userService.isLoggedIn
            ? MainNavigation(userService: widget.userService)
            : AuthScreen(
                userService: widget.userService,
                onAuthSuccess: (authContext) {
                  Navigator.of(authContext).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (c, a, s) =>
                          MainNavigation(userService: widget.userService),
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (c, animation, s, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              );

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (c, a, s) => nextScreen,
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (c, animation, s, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.userService.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.background : AppTheme.lightBackground,
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/splashh.json',
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (context, error, stackTrace) => const SizedBox(), 
            ),
          ),
          // Theme Overlay to fix color/theme differences
          Positioned.fill(
            child: Container(
              color: isDark 
                  ? AppTheme.background.withValues(alpha: 0.85) 
                  : AppTheme.lightBackground.withValues(alpha: 0.85),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                                .withValues(alpha: 0.4),
                            blurRadius: 60,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: (isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary)
                                .withValues(alpha: 0.4),
                            blurRadius: 60,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppTheme.purpleAccent.withValues(alpha: 0.3),
                                  AppTheme.cyanAccent.withValues(alpha: 0.3),
                                ]
                              : [
                                  AppTheme.lightPrimary.withValues(alpha: 0.3),
                                  AppTheme.lightSecondary.withValues(alpha: 0.3),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                              .withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'QUICK_QUIZ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                    shadows: [
                      Shadow(
                        color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                            .withValues(alpha: 0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'POWERED BY KNOWLEDGE',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 4,
                    color: (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)
                        .withValues(alpha: 0.6),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
