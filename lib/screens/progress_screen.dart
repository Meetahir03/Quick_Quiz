import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';

class ProgressScreen extends StatefulWidget {
  final UserDataService userService;
  const ProgressScreen({super.key, required this.userService});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    widget.userService.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.userService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final us = widget.userService;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.bar_chart,
            color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary),
        title: Text('XP PROGRESS',
            style: TextStyle(
                color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProgressCircle(isDark, us),
              const SizedBox(height: 32),
              _buildStatsGrid(isDark, us),
              const SizedBox(height: 24),
              if (us.weakAreas.isNotEmpty) ...[
                _buildAreasForImprovement(isDark, us),
                const SizedBox(height: 24),
              ],
              _buildHistoryTokens(isDark, us),
              const SizedBox(height: 24),
              _buildPerformanceChart(isDark, us),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(isDark, us),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle(bool isDark, UserDataService us) {
    final accuracyVal = us.accuracy / 100;
    final topPercent = (100 - us.accuracy * 0.5).clamp(1, 99).toInt();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text('Your Progress',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            )),
        const SizedBox(height: 8),
        Text(
          us.totalQuizzes > 0
              ? 'You\'re performing better than $topPercent% of\nplayers this week.'
              : 'Complete your first quiz to see\nyour progress!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: accuracyVal.clamp(0, 1).toDouble(),
                strokeWidth: 12,
                backgroundColor:
                    isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                color: isDark ? AppTheme.purpleAccent : AppTheme.lightPrimary,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${us.accuracy.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        )),
                    Text('ACCURACY',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        )),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStatsGrid(bool isDark, UserDataService us) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildStatRow(Icons.quiz,
              isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary,
              'Total Quizzes', '${us.totalQuizzes}', isDark),
          Divider(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              height: 32),
          _buildStatRow(Icons.check_circle,
              isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
              'Correct Answers', '${us.correctAnswers}', isDark),
          Divider(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              height: 32),
          _buildStatRow(Icons.local_fire_department,
              isDark ? AppTheme.pinkAccent : AppTheme.lightWarm,
              'Current Streak', '${us.streak} Days', isDark),
          Divider(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              height: 32),
          _buildStatRow(Icons.star,
              isDark ? AppTheme.goldAccent : const Color(0xFFBFA23D),
              'Level', '${us.level}', isDark),
        ],
      ),
    );
  }

  Widget _buildStatRow(
      IconData icon, Color color, String title, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAreasForImprovement(bool isDark, UserDataService us) {
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
            children: [
              Icon(Icons.warning,
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                  size: 16),
              const SizedBox(width: 8),
              Text('Areas for Improvement',
                  style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: us.weakAreas
                .map((area) => _buildImprovementBadge(
                    area, isDark ? AppTheme.pinkAccent : AppTheme.lightWarm, isDark))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildImprovementBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.background : AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
              style: TextStyle(
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
          const SizedBox(width: 8),
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(bool isDark, UserDataService us) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance\nChart',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
          const SizedBox(height: 8),
          Text('Weekly Score Consistency',
              style: TextStyle(
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                  fontSize: 12)),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()],
                              style: TextStyle(
                                  color: isDark
                                      ? AppTheme.textSecondary
                                      : AppTheme.lightTextSecondary,
                                  fontSize: 10)),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppTheme.surfaceHighlight
                        : AppTheme.lightSurfaceHighlight,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final val = us.weeklyScores[i];
                  final isHigh = val > 60;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: val > 0 ? val : 5, // min bar height
                        color: isHigh
                            ? (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                            : (isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary),
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTokens(bool isDark, UserDataService us) {
    if (us.history.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history,
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                  size: 20),
              const SizedBox(width: 8),
              Text('Recent Results History',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: us.history.take(15).map((record) {
              final cat = record['category'] ?? 'Quiz';
              final correct = record['correct'] ?? 0;
              final total = record['total'] ?? 0;
              final pct = total > 0 ? (correct / total) : 0.0;
              Color color = isDark ? AppTheme.pinkAccent : Colors.redAccent;
              if (pct >= 0.8) color = isDark ? AppTheme.cyanAccent : Colors.green;
              else if (pct >= 0.5) color = isDark ? AppTheme.goldAccent : Colors.orange;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$cat ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      ),
                    ),
                    Text(
                      '$correct/$total',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(bool isDark, UserDataService us) {
    final categories = us.categoryTotal.keys.toList();
    if (categories.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category Breakdown',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
          const SizedBox(height: 20),
          ...categories.map((cat) {
            final correct = us.categoryCorrect[cat] ?? 0;
            final total = us.categoryTotal[cat] ?? 1;
            final pct = (correct / total * 100);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cat,
                          style: TextStyle(
                              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                              fontWeight: FontWeight.w500)),
                      Text('${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0, 1),
                      minHeight: 6,
                      backgroundColor: isDark
                          ? AppTheme.surfaceHighlight
                          : AppTheme.lightSurfaceHighlight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
