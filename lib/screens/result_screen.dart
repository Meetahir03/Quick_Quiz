import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';
import 'loading_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final String category;
  final UserDataService userService;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    this.category = 'ALL',
    required this.userService,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _scaleIn;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _scaleIn = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  String get _feedbackMessage {
    final ratio = widget.correctAnswers / widget.totalQuestions;
    if (ratio >= 0.9) return 'OUTSTANDING!';
    if (ratio >= 0.7) return 'EXCELLENT WORK!';
    if (ratio >= 0.5) return 'GOOD EFFORT!';
    return 'KEEP PRACTICING!';
  }

  String get _formattedTime {
    final minutes = widget.timeTaken.inMinutes;
    final seconds = widget.timeTaken.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int get _accuracy =>
      ((widget.correctAnswers / widget.totalQuestions) * 100).toInt();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final us = widget.userService;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        body: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scaleIn,
                    child: _buildTrophyHeader(isDark),
                  ),
                  const SizedBox(height: 32),
                  _buildStatCard(Icons.track_changes, 'ACCURACY', '$_accuracy%', isDark),
                  const SizedBox(height: 16),
                  _buildStatCard(Icons.timer, 'TIME TAKEN', _formattedTime, isDark),
                  const SizedBox(height: 16),
                  _buildStatCard(Icons.check_circle, 'CORRECT',
                      '${widget.correctAnswers}', isDark),
                  const SizedBox(height: 32),
                  _buildLevelProgressCard(isDark, us),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDark
                  ? [AppTheme.purpleAccent, AppTheme.cyanAccent]
                  : [AppTheme.lightPrimary, AppTheme.lightSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                      .withValues(alpha: 0.4),
                  blurRadius: 30, spreadRadius: 5),
            ],
          ),
          child: const Center(
            child: Icon(Icons.emoji_events, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${widget.correctAnswers}/${widget.totalQuestions}',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w300,
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _feedbackMessage,
          style: TextStyle(
            color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
            width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon,
              color: isDark ? AppTheme.purpleAccent : AppTheme.lightPrimary, size: 28),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                  fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  fontSize: 20, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLevelProgressCard(bool isDark, UserDataService us) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LEVEL UP PROGRESS',
                      style: TextStyle(
                          color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Level ${us.level}',
                      style: TextStyle(
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                          fontSize: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+${widget.score} XP',
                      style: TextStyle(
                          color: isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary,
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Level ${us.level + 1} next',
                      style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                          fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.background : AppTheme.lightSurfaceHighlight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: min(1.0, us.xp / us.xpToNextLevel),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: isDark
                        ? [AppTheme.purpleAccent, AppTheme.cyanAccent]
                        : [AppTheme.lightPrimary, AppTheme.lightSecondary]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: isDark
                ? [AppTheme.purpleAccent, AppTheme.cyanAccent]
                : [AppTheme.lightPrimary, AppTheme.lightSecondary]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                      .withValues(alpha: 0.3),
                  blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => LoadingScreen(
                        category: widget.category,
                        userService: widget.userService),
                    transitionDuration: const Duration(milliseconds: 400),
                    transitionsBuilder: (c, animation, s, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: Colors.white),
                  SizedBox(width: 8),
                  Text('PLAY AGAIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.home,
                color: isDark ? Colors.white : AppTheme.lightTextPrimary),
            label: Text('GO HOME',
                style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                  width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
            ),
          ),
        )
      ],
    );
  }
}
