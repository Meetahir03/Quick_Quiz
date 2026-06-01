import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';
import 'home_screen.dart';
import 'loading_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final UserDataService userService;
  const MainNavigation({super.key, required this.userService});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(userService: widget.userService),
          _QuizLauncherTab(userService: widget.userService),
          ProgressScreen(userService: widget.userService),
          ProfileScreen(userService: widget.userService),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                  .withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'PLAY'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'PROGRESS'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
          ],
        ),
      ),
    );
  }
}

class _QuizLauncherTab extends StatelessWidget {
  final UserDataService userService;
  const _QuizLauncherTab({required this.userService});

  void _launchQuiz(BuildContext context, String category) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, s) =>
            LoadingScreen(category: category, userService: userService),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (c, animation, s, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHOOSE QUIZ',
          style: TextStyle(
            color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a topic to start:',
                style: TextStyle(
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              _buildCard(context, Icons.shuffle, 'QUICK PLAY',
                  '10 random questions from all topics',
                  isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary, 'ALL'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.science, 'SCIENCE & TECH',
                  '10 questions on science and technology',
                  isDark ? AppTheme.purpleAccent : const Color(0xFF6A8E3F), 'SCIENCE'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.account_balance, 'HISTORY',
                  '10 questions on world history',
                  isDark ? AppTheme.goldAccent : AppTheme.lightWarm, 'HISTORY'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.star, 'POP CULTURE',
                  '10 questions on movies, music & more',
                  isDark ? AppTheme.pinkAccent : const Color(0xFFC0694F), 'POP CULTURE'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.movie, 'INDIAN CINEMA',
                  '10 questions on Indian movies',
                  isDark ? const Color(0xFFFFB74D) : Colors.orange, 'INDIAN CINEMA'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.calculate, 'MATHS',
                  '10 questions on numbers & logic',
                  isDark ? Colors.blueAccent : Colors.blue, 'MATHS'),
              const SizedBox(height: 16),
              _buildCard(context, Icons.public, 'GENERAL KNOWLEDGE',
                  '10 questions on geography & facts',
                  isDark ? Colors.greenAccent : Colors.green, 'GK'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title,
      String sub, Color color, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _launchQuiz(context, category),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(sub,
                      style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                          fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.play_arrow, color: color, size: 28),
          ],
        ),
      ),
    );
  }
}
