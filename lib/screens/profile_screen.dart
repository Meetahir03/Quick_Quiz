import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';
import 'auth_screen.dart';
import 'main_navigation.dart';

class ProfileScreen extends StatefulWidget {
  final UserDataService userService;
  const ProfileScreen({super.key, required this.userService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text(
          'PROFILE',
          style: TextStyle(
            color: isDark ? AppTheme.purpleAccent : AppTheme.lightPrimary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
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
              _buildUserHeaderCard(isDark, us),
              const SizedBox(height: 16),
              _buildStatsRow(isDark, us),
              const SizedBox(height: 24),
              Text('EARNED ACHIEVEMENTS',
                  style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildAchievementsRow(isDark, us),
              const SizedBox(height: 24),
              Text('SETTINGS',
                  style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      letterSpacing: 1.5, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildSettingsList(isDark, us),
              const SizedBox(height: 24),
              _buildDisconnectButton(isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeaderCard(bool isDark, UserDataService us) {
    final xpProgress =
        us.xpToNextLevel > 0 ? (us.xp / us.xpToNextLevel).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
                            .withValues(alpha: 0.5),
                        blurRadius: 15, spreadRadius: 2),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                  child: Text(
                    us.userName.isNotEmpty ? us.userName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  us.isGuest ? 'GUEST' : (us.level >= 10 ? 'PRO' : 'LV${us.level}'),
                  style: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 10, fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(us.userName.isNotEmpty ? us.userName : 'Player',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
          const SizedBox(height: 4),
          Text('LEVEL ${us.level} | ${us.xp} XP',
              style: TextStyle(
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                  letterSpacing: 1.1)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpProgress,
              minHeight: 6,
              backgroundColor: isDark ? AppTheme.background : AppTheme.lightSurfaceHighlight,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark, UserDataService us) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('TOTAL SCORE', _formatScore(us.totalScore), false, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('QUIZZES', '${us.totalQuizzes}', false, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('STREAK', '${us.streak}', true, isDark)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, bool showFire, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
            width: 0.5),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                  fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
              if (showFire) ...[
                const SizedBox(width: 4),
                Icon(Icons.local_fire_department,
                    color: isDark ? AppTheme.pinkAccent : AppTheme.lightWarm, size: 16),
              ]
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAchievementsRow(bool isDark, UserDataService us) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBadge(Icons.rocket_launch, isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary,
              us.totalQuizzes < 1, 'First Quiz!', isDark),
          _buildBadge(Icons.emoji_events, isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
              us.totalQuizzes < 10, '10 Quizzes!', isDark),
          _buildBadge(Icons.flash_on, isDark ? AppTheme.pinkAccent : AppTheme.lightWarm,
              us.streak < 5, '5 Day Streak!', isDark),
          _buildBadge(Icons.military_tech, isDark ? AppTheme.goldAccent : const Color(0xFFBFA23D),
              us.level < 5, 'Level 5!', isDark),
          _buildBadge(Icons.lock, isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              true, 'it\'s locked', isDark),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color, bool locked, String tip, bool isDark) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locked ? '🔒 $tip' : '🎉 $tip'),
              duration: const Duration(seconds: 1)),
        );
      },
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: locked
              ? (isDark ? AppTheme.background : AppTheme.lightBackground)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: locked
                  ? (isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight)
                  : color.withValues(alpha: 0.5)),
          boxShadow: locked ? [] : [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8)],
        ),
        child: Icon(icon,
            color: locked
                ? (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)
                : color,
            size: 24),
      ),
    );
  }

  Widget _buildSettingsList(bool isDark, UserDataService us) {
    return Column(
      children: [
        _buildSettingsItem(Icons.person, 'Edit Profile',
            onTap: () => _showEditProfileDialog(isDark, us),
            iconColor: isDark ? AppTheme.purpleAccent : AppTheme.lightPrimary, isDark: isDark),
        const SizedBox(height: 12),
        _buildSettingsItem(Icons.notifications, 'Notifications',
            hasToggle: true, toggleValue: us.notificationsEnabled,
            onToggle: (v) => us.toggleNotifications(v),
            iconColor: isDark ? AppTheme.cyanAccent : AppTheme.lightSecondary, isDark: isDark),
        const SizedBox(height: 12),
        _buildSettingsItem(Icons.dark_mode, 'Dark Mode',
            hasToggle: true, toggleValue: us.isDarkMode,
            onToggle: (v) => us.toggleDarkMode(v),
            iconColor: isDark ? AppTheme.pinkAccent : AppTheme.lightWarm, isDark: isDark),
        const SizedBox(height: 12),
        _buildSettingsItem(Icons.info, 'App Info',
            onTap: () => _showAppInfoDialog(isDark),
            iconColor: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary, isDark: isDark),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title,
      {bool hasToggle = false, bool toggleValue = false,
      Function(bool)? onToggle, VoidCallback? onTap,
      required Color iconColor, required bool isDark}) {
    return GestureDetector(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        fontSize: 16, fontWeight: FontWeight.w500))),
            if (hasToggle)
              Switch(
                value: toggleValue,
                onChanged: onToggle,
                activeThumbColor: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                activeTrackColor:
                    (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary).withValues(alpha: 0.3),
                inactiveThumbColor:
                    isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                inactiveTrackColor:
                    isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              )
            else
              Icon(Icons.chevron_right,
                  color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnectButton(bool isDark) {
    if (widget.userService.isGuest) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _handleLogout(isDark, isGuest: true),
          icon: Icon(Icons.person_add,
              color: isDark ? Colors.black : Colors.white),
          label: Text('SIGN UP TO SAVE PROGRESS',
              style: TextStyle(
                  color: isDark ? Colors.black : Colors.white,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleLogout(isDark),
        icon: Icon(Icons.logout, color: isDark ? AppTheme.pinkAccent : Colors.red),
        label: Text('DISCONNECT SESSION',
            style: TextStyle(
                color: isDark ? AppTheme.pinkAccent : Colors.red,
                letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
              color: (isDark ? AppTheme.pinkAccent : Colors.red).withValues(alpha: 0.5),
              width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
        ),
      ),
    );
  }

  void _handleLogout(bool isDark, {bool isGuest = false}) {
    if (isGuest) {
      _performLogout();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Disconnect Session?',
            style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
        content: Text('Are you sure you want to log out?',
            style: TextStyle(
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL',
                style: TextStyle(color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              _performLogout();
            },
            child: Text(isGuest ? 'SIGN UP' : 'DISCONNECT',
                style: TextStyle(color: isDark ? AppTheme.pinkAccent : Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    await widget.userService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => AuthScreen(
            userService: widget.userService,
            onAuthSuccess: (authContext) {
              Navigator.of(authContext).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) =>
                      MainNavigation(userService: widget.userService),
                ),
                (_) => false,
              );
            },
          ),
        ),
        (_) => false,
      );
    }
  }

  void _showEditProfileDialog(bool isDark, UserDataService us) {
    final nameController = TextEditingController(text: us.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Profile',
            style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
        content: TextField(
          controller: nameController,
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL',
                style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              us.updateProfile(nameController.text.trim());
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated to "${nameController.text}"')),
              );
            },
            child: Text('SAVE',
                style: TextStyle(color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('App Info',
            style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QuickQuiz v1.0.0',
                style: TextStyle(
                    color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('A modern quiz app with gamification , The Smart Expense Tracker App is a simple mobile application built using Flutter and Dart that helps users manage their daily expenses. It allows users to add, view, and delete expenses with details like amount, category, and date. The app stores data locally using Hive and provides basic insights such as total spending, making it easy to track and control personal finances.',
                style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
            const SizedBox(height: 8),
            Text('Built with Flutter ⚡',
                style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CLOSE',
                style: TextStyle(color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
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
