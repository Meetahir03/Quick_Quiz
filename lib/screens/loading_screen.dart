import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../models/quiz_data.dart';
import '../services/user_data_service.dart';
import 'play_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String category;
  final UserDataService userService;
  const LoadingScreen({super.key, this.category = 'ALL', required this.userService});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final questions = QuizBank.getQuestions(widget.category);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (c, a, s) => PlayScreen(
              questions: questions.take(10).toList(),
              category: widget.category,
              userService: widget.userService,
            ),
            transitionDuration: const Duration(milliseconds: 400),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.background : AppTheme.lightBackground,
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/background.json',
              fit: BoxFit.cover,
              repeat: true,
              errorBuilder: (context, error, stackTrace) => const SizedBox(), 
            ),
          ),
          // Theme Overlay (Dark or Light tint to mix animation with theme)
          Positioned.fill(
            child: Container(
              color: isDark 
                  ? AppTheme.background.withOpacity(0.8) 
                  : AppTheme.lightBackground.withOpacity(0.8),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: RotationTransition(
                                turns: _controller,
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return SweepGradient(
                                      startAngle: 0.0,
                                      endAngle: 3.14 * 2,
                                      stops: const [0.0, 0.5, 1.0],
                                      colors: isDark
                                          ? [Colors.transparent, AppTheme.purpleAccent, AppTheme.cyanAccent]
                                          : [Colors.transparent, AppTheme.lightSecondary, AppTheme.lightPrimary],
                                    ).createShader(rect);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                              ),
                              child: Icon(Icons.flash_on,
                                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                                  size: 30),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text('Initializing Quiz',
                            style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(
                          'Loading ${widget.category == "ALL" ? "mixed" : widget.category.toLowerCase()} questions...',
                          style: TextStyle(
                              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'Q U I C K _ Q U I Z  //  V . 1 . 0',
                    style: TextStyle(
                        color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                        fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
