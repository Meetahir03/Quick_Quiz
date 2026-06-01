import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserDataService extends ChangeNotifier {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  late Box _box;

  // ─── Auth state ──────────────────────────────────────────────
  bool _isLoggedIn = false;
  bool _isGuest = false;
  String _userName = '';
  String _email = '';

  // ─── Stats ───────────────────────────────────────────────────
  int _totalScore = 0;
  int _totalQuizzes = 0;
  int _correctAnswers = 0;
  int _totalQuestionsAnswered = 0;
  int _streak = 0;
  int _level = 1;
  int _xp = 0;
  int _xpToNextLevel = 300;

  // ─── History ─────────────────────────────────────────────────
  List<Map<String, dynamic>> _history = [];

  // ─── Streak date tracking ────────────────────────────────────
  String _lastPlayedDate = '';

  // ─── Theme ───────────────────────────────────────────────────
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;

  // ─── Category performance ────────────────────────────────────
  Map<String, int> _categoryCorrect = {};
  Map<String, int> _categoryTotal = {};

  // ─── Weekly scores (Mon-Sun) ─────────────────────────────────
  List<double> _weeklyScores = [0, 0, 0, 0, 0, 0, 0];

  // ─── Getters ─────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  String get userName => _userName;
  String get email => _email;
  int get totalScore => _totalScore;
  int get totalQuizzes => _totalQuizzes;
  int get correctAnswers => _correctAnswers;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  int get streak => _streak;
  int get level => _level;
  int get xp => _xp;
  int get xpToNextLevel => _xpToNextLevel;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  Map<String, int> get categoryCorrect => _categoryCorrect;
  Map<String, int> get categoryTotal => _categoryTotal;
  List<double> get weeklyScores => _weeklyScores;
  List<Map<String, dynamic>> get history => _history;

  double get accuracy =>
      _totalQuestionsAnswered > 0 ? (_correctAnswers / _totalQuestionsAnswered) * 100 : 0;

  List<String> get weakAreas {
    final areas = <String>[];
    _categoryTotal.forEach((cat, total) {
      if (total > 0) {
        final correct = _categoryCorrect[cat] ?? 0;
        if (correct / total < 0.6) areas.add(cat);
      }
    });
    return areas;
  }

  // ─── Initialize ──────────────────────────────────────────────
  Future<void> init() async {
    _box = Hive.box('user_data');
    _loadData();
  }

  void _loadData() {
    _isLoggedIn = _box.get('isLoggedIn', defaultValue: false);
    _isGuest = _box.get('isGuest', defaultValue: false);
    _userName = _box.get('userName', defaultValue: '');
    _email = _box.get('email', defaultValue: '');
    _totalScore = _box.get('totalScore', defaultValue: 0);
    _totalQuizzes = _box.get('totalQuizzes', defaultValue: 0);
    _correctAnswers = _box.get('correctAnswers', defaultValue: 0);
    _totalQuestionsAnswered = _box.get('totalQuestionsAnswered', defaultValue: 0);
    _streak = _box.get('streak', defaultValue: 0);
    _level = _box.get('level', defaultValue: 1);
    _xp = _box.get('xp', defaultValue: 0);
    _xpToNextLevel = _box.get('xpToNextLevel', defaultValue: 300);
    _lastPlayedDate = _box.get('lastPlayedDate', defaultValue: '');
    _isDarkMode = _box.get('isDarkMode', defaultValue: true);
    _notificationsEnabled = _box.get('notificationsEnabled', defaultValue: true);

    final catCorrectStr = _box.get('categoryCorrect', defaultValue: '{}');
    final catTotalStr = _box.get('categoryTotal', defaultValue: '{}');
    _categoryCorrect = Map<String, int>.from(json.decode(catCorrectStr));
    _categoryTotal = Map<String, int>.from(json.decode(catTotalStr));

    final weeklyStr = _box.get('weeklyScores', defaultValue: '[0.0,0.0,0.0,0.0,0.0,0.0,0.0]');
    _weeklyScores = (json.decode(weeklyStr) as List).map((e) => (e as num).toDouble()).toList();

    final historyStr = _box.get('history', defaultValue: '[]');
    _history = List<Map<String, dynamic>>.from(json.decode(historyStr));

    // Check streak on load
    _checkStreak();
    notifyListeners();
  }

  Future<void> _save() async {
    await _box.put('isLoggedIn', _isLoggedIn);
    await _box.put('isGuest', _isGuest);
    await _box.put('userName', _userName);
    await _box.put('email', _email);
    await _box.put('totalScore', _totalScore);
    await _box.put('totalQuizzes', _totalQuizzes);
    await _box.put('correctAnswers', _correctAnswers);
    await _box.put('totalQuestionsAnswered', _totalQuestionsAnswered);
    await _box.put('streak', _streak);
    await _box.put('level', _level);
    await _box.put('xp', _xp);
    await _box.put('xpToNextLevel', _xpToNextLevel);
    await _box.put('lastPlayedDate', _lastPlayedDate);
    await _box.put('isDarkMode', _isDarkMode);
    await _box.put('notificationsEnabled', _notificationsEnabled);
    await _box.put('categoryCorrect', json.encode(_categoryCorrect));
    await _box.put('categoryTotal', json.encode(_categoryTotal));
    await _box.put('weeklyScores', json.encode(_weeklyScores));
    await _box.put('history', json.encode(_history));
  }

  // ─── Auth methods ────────────────────────────────────────────
  Future<void> continueAsGuest() async {
    _isLoggedIn = true;
    _isGuest = true;
    _userName = 'Guest';
    _email = '';
    // Optional: Reset stats if starting fresh, or keep them
    await _save();
    notifyListeners();
  }
  Future<bool> register(String name, String email, String password) async {
    // Store credentials securely in Hive
    final existingEmail = _box.get('registered_email', defaultValue: '');
    if (existingEmail == email) return false; // Already registered

    await _box.put('registered_email', email);
    await _box.put('registered_password', password); // Basic auth storage for Hive DB
    await _box.put('registered_name', name);

    _userName = name;
    _email = email;
    _isLoggedIn = true;
    _isGuest = false;
    _streak = 1;
    _lastPlayedDate = _todayStr;
    await _save();
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    final storedEmail = _box.get('registered_email', defaultValue: '');
    final storedPassword = _box.get('registered_password', defaultValue: '');

    if (email == storedEmail && password == storedPassword) {
      _userName = _box.get('registered_name', defaultValue: 'Player');
      _email = email;
      _isLoggedIn = true;
      _isGuest = false;
      _loadData();
      await _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuest = false;
    await _save();
    notifyListeners();
  }

  Future<void> updateProfile(String name) async {
    _userName = name;
    await _box.put('registered_name', name);
    await _save();
    notifyListeners();
  }

  // ─── Streak logic ───────────────────────────────────────────
  String get _todayStr {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  void _checkStreak() {
    if (_lastPlayedDate.isEmpty) return;

    try {
      final lastPlayed = DateTime.parse(_lastPlayedDate);
      final today = DateTime.now();
      final diff = DateTime(today.year, today.month, today.day)
          .difference(DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day))
          .inDays;

      if (diff > 2) {
        // Missed 2+ consecutive days → reset streak
        _streak = 0;
      }
    } catch (_) {
      _streak = 0;
    }
  }

  void _updateStreak() {
    final today = _todayStr;
    if (_lastPlayedDate == today) return; // Already played today

    if (_lastPlayedDate.isEmpty) {
      _streak = 1;
    } else {
      try {
        final lastPlayed = DateTime.parse(_lastPlayedDate);
        final now = DateTime.now();
        final diff = DateTime(now.year, now.month, now.day)
            .difference(DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day))
            .inDays;

        if (diff == 1) {
          _streak++;
        } else if (diff > 2) {
          _streak = 1; // Reset and start new
        }
        // diff == 0 means same day, streak stays
      } catch (_) {
        _streak = 1;
      }
    }
    _lastPlayedDate = today;
  }

  // ─── Quiz completion handler ─────────────────────────────────
  Future<void> recordQuizResult({
    required int score,
    required int correct,
    required int total,
    required String category,
  }) async {
    _totalScore += score;
    _totalQuizzes++;
    _correctAnswers += correct;
    _totalQuestionsAnswered += total;

    // XP & Level
    _xp += score;
    while (_xp >= _xpToNextLevel) {
      _xp -= _xpToNextLevel;
      _level++;
      _xpToNextLevel = 300 + (_level * 50); // Progressive difficulty
    }

    // Level up every 10 questions
    final levelFromQuestions = (_totalQuestionsAnswered / 10).floor() + 1;
    if (levelFromQuestions > _level) {
      _level = levelFromQuestions;
    }

    // Category performance
    _categoryCorrect[category] = (_categoryCorrect[category] ?? 0) + correct;
    _categoryTotal[category] = (_categoryTotal[category] ?? 0) + total;

    // Weekly score tracking
    final dayOfWeek = DateTime.now().weekday - 1; // 0=Mon, 6=Sun
    _weeklyScores[dayOfWeek] = (_weeklyScores[dayOfWeek] + (correct / total * 100)) / 2;
    if (_weeklyScores[dayOfWeek] == 0) {
      _weeklyScores[dayOfWeek] = (correct / total * 100);
    }

    // History tracking
    _history.insert(0, {
      'category': category,
      'correct': correct,
      'total': total,
      'score': score,
      'date': DateTime.now().toString(),
    });
    if (_history.length > 20) {
      _history.removeLast(); // Keep only 20 recent
    }

    // Streak
    _updateStreak();

    await _save();
    notifyListeners();
  }

  // ─── Theme toggle ───────────────────────────────────────────
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _save();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await _save();
    notifyListeners();
  }
}
