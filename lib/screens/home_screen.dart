import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserDataService userService;
  const HomeScreen({super.key, required this.userService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 15.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    widget.userService.addListener(_refresh);
  }

  @override
  void dispose() {
    _glowController.dispose();
    widget.userService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _startQuiz({String category = 'ALL'}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, s) =>
            LoadingScreen(category: category, userService: widget.userService),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (c, animation, s, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
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
    final us = widget.userService;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
            child: Text(
              us.userName.isNotEmpty ? us.userName[0].toUpperCase() : 'Q',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          'QUIZ_ENGINE',
          style: TextStyle(
            color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                    .withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(isDark, us),
              const SizedBox(height: 32),
              _buildStartQuizButton(isDark),
              const SizedBox(height: 32),
              _buildMegaChallengeCard(isDark),
              const SizedBox(height: 32),
              _buildCategoriesList(isDark),
              const SizedBox(height: 32),
              _buildBottomStatsCard(isDark, us),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark, UserDataService us) {
    final xpProgress = us.xpToNextLevel > 0 ? us.xp / us.xpToNextLevel : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text(
                'Hey, ${us.userName.isNotEmpty ? us.userName : "Player"} 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: isDark ? AppTheme.pinkAccent : AppTheme.lightWarm, size: 16),
                    const SizedBox(width: 4),
                    Text('${us.streak} STREAK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ready for your daily\ngrind?',
            style: TextStyle(
              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LEVEL ${us.level}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.purpleAccent : AppTheme.lightPrimary,
                  )),
              Text('${us.xp} / ${us.xpToNextLevel} XP',
                  style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                    fontSize: 12,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpProgress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: isDark ? AppTheme.background : AppTheme.lightSurfaceHighlight,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartQuizButton(bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: () => _startQuiz(),
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppTheme.surface : AppTheme.lightSurface,
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                        .withValues(alpha: 0.5),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: (isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary)
                        .withValues(alpha: 0.3),
                    blurRadius: _glowAnimation.value * 1.5,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 48,
                        color: isDark ? Colors.white : AppTheme.lightTextPrimary),
                    const SizedBox(height: 8),
                    Text('START QUIZ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMegaChallengeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.pinkAccent, const Color(0xFF880E4F)]
              : [AppTheme.lightWarm, const Color(0xFF8B6B3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('LIMITED TIME!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Text('500+ XP',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('MEGA BLITZ CHALLENGE',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Master 10 pop-culture questions in 60 seconds.',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _startQuiz(category: 'POP CULTURE'),
              child: Text('CLAIM REWARD',
                  style: TextStyle(
                    color: isDark ? Colors.redAccent : AppTheme.lightWarm,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoriesList(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
            TextButton(
              onPressed: () {},
              child: Text('SEE ALL',
                  style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryCard('SCIENCE', Icons.science,
                  isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary, '🔬', isDark),
              _buildCategoryCard('HISTORY', Icons.account_balance,
                  isDark ? AppTheme.purpleAccent : AppTheme.lightWarm, '🏛️', isDark),
              _buildCategoryCard('POP CULTURE', Icons.star,
                  isDark ? AppTheme.pinkAccent : const Color(0xFFC0694F), '🎬', isDark),
              _buildCategoryCard('INDIAN CINEMA', Icons.movie,
                  isDark ? const Color(0xFFFFB74D) : Colors.orange, '🎥', isDark),
              _buildCategoryCard('MATHS', Icons.calculate,
                  isDark ? Colors.blueAccent : Colors.blue, '🧮', isDark),
              _buildCategoryCard('GK', Icons.public,
                  isDark ? Colors.greenAccent : Colors.green, '🌍', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      String title, IconData icon, Color color, String emoji, bool isDark) {
    return GestureDetector(
      onTap: () => _startQuiz(category: title),
      child: Container(
        width: 115,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border(bottom: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.permanentMarker(
                fontSize: 10,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(emoji, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStatsCard(bool isDark, UserDataService us) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
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
                  Text('ACCURACY',
                      style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                          fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${us.accuracy.toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
                      const SizedBox(width: 8),
                      Icon(Icons.trending_up,
                          color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary, size: 20),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL SCORE',
                      style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                          fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(_formatScore(us.totalScore),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    if (score >= 1000) return '${(score / 1000).toStringAsFixed(1)}K';
    return score.toString();
  }
}
