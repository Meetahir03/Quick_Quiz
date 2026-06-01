import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../models/quiz_data.dart';
import '../services/user_data_service.dart';
import 'result_screen.dart';

class PlayScreen extends StatefulWidget {
  final List<Question> questions;
  final String category;
  final UserDataService userService;

  const PlayScreen({
    super.key,
    required this.questions,
    this.category = 'ALL',
    required this.userService,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _selectedOption = -1;
  bool _isAnswerChecked = false;
  int _score = 0;
  int _correctAnswers = 0;
  int _lives = 3;

  late AnimationController _timerController;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late DateTime _quizStartTime;

  // Category-specific colors
  Color get _categoryColor {
    switch (widget.category) {
      case 'SCIENCE':
        return _isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary;
      case 'HISTORY':
        return _isDark ? AppTheme.goldAccent : AppTheme.lightWarm;
      case 'POP CULTURE':
        return _isDark ? AppTheme.pinkAccent : const Color(0xFFC0694F);
      case 'INDIAN CINEMA':
        return _isDark ? const Color(0xFFFFB74D) : Colors.orange;
      case 'MATHS':
        return _isDark ? Colors.blueAccent : Colors.blue;
      case 'GK':
        return _isDark ? Colors.greenAccent : Colors.green;
      default:
        return _isDark ? AppTheme.purpleAccent : AppTheme.lightSecondary;
    }
  }

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _quizStartTime = DateTime.now();

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..forward();

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isAnswerChecked) {
        _handleTimeUp();
      }
    });

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleTimeUp() {
    if (!mounted) return;
    setState(() {
      _isAnswerChecked = true;
      _lives--;
    });
    _feedbackController.forward();
    _goToNextQuestion();
  }

  void _selectOption(int index) {
    if (_isAnswerChecked) return;
    _timerController.stop();
    final currentQ = widget.questions[_currentQuestionIndex];
    final isCorrect = index == currentQ.correctIndex;

    setState(() {
      _selectedOption = index;
      _isAnswerChecked = true;
      if (isCorrect) {
        _correctAnswers++;
        _score += currentQ.points;
      } else {
        _lives--;
      }
    });
    _feedbackController.forward(from: 0);
    _goToNextQuestion();
  }

  void _goToNextQuestion() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      if (_currentQuestionIndex < widget.questions.length - 1 && _lives > 0) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOption = -1;
          _isAnswerChecked = false;
        });
        _timerController.reset();
        _timerController.forward();
      } else {
        final timeTaken = DateTime.now().difference(_quizStartTime);

        // Record result in user data
        widget.userService.recordQuizResult(
          score: _score,
          correct: _correctAnswers,
          total: _currentQuestionIndex + 1,
          category: widget.category,
        );

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (c, a, s) => ResultScreen(
              score: _score,
              totalQuestions: widget.questions.length,
              correctAnswers: _correctAnswers,
              timeTaken: timeTaken,
              category: widget.category,
              userService: widget.userService,
            ),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (c, animation, s, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.questions[_currentQuestionIndex];
    final letters = ['A', 'B', 'C', 'D'];
    final isDark = _isDark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _showQuitDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showQuitDialog,
          ),
          title: Column(
            children: [
              // Category badge with unique font
              Text(
                widget.category,
                style: GoogleFonts.permanentMarker(
                  fontSize: 10,
                  color: _categoryColor,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${_currentQuestionIndex + 1} / ${widget.questions.length}',
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      index < _lives ? Icons.favorite : Icons.favorite_border,
                      color: index < _lives
                          ? (isDark ? AppTheme.pinkAccent : AppTheme.lightWarm)
                          : (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary),
                      size: 18,
                    ),
                  );
                }),
              ),
            )
          ],
        ),
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
            // Theme Overlay 
            Positioned.fill(
              child: Container(
                color: isDark 
                    ? AppTheme.background.withOpacity(0.8) 
                    : AppTheme.lightBackground.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Timer
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: AnimatedBuilder(
                        animation: _timerController,
                        builder: (context, child) {
                          final remaining = 1.0 - _timerController.value;
                          return CircularProgressIndicator(
                            value: remaining,
                            color: remaining > 0.3
                                ? _categoryColor
                                : (isDark ? AppTheme.pinkAccent : Colors.red),
                            backgroundColor: isDark
                                ? AppTheme.surfaceHighlight
                                : AppTheme.lightSurfaceHighlight,
                            strokeWidth: 4,
                          );
                        },
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _timerController,
                      builder: (context, child) {
                        final seconds =
                            (15 * (1.0 - _timerController.value)).ceil();
                        return Text(
                          '$seconds',
                          style: TextStyle(
                            color: (1.0 - _timerController.value) > 0.3
                                ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                                : (isDark ? AppTheme.pinkAccent : Colors.red),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Question Card
              ScaleTransition(
                scale: _feedbackScale,
                child: _buildQuestionCard(currentQ, isDark),
              ),
              const SizedBox(height: 16),

              // Options
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currentQ.options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildOptionCard(
                        index,
                        letters[index],
                        currentQ.options[index],
                        isCorrect: index == currentQ.correctIndex,
                        isDark: isDark,
                      ),
                    );
                  },
                ),
              ),

              // Progress bar
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      (_currentQuestionIndex + 1) / widget.questions.length,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        _categoryColor,
                        isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                      ]),
                      borderRadius: BorderRadius.circular(2),
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
    );
  }

  Widget _buildQuestionCard(Question q, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _categoryColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  q.category,
                  style: GoogleFonts.permanentMarker(
                    fontSize: 9,
                    color: _categoryColor,
                  ),
                ),
              ),
              Text('${q.points} PTS',
                  style: TextStyle(
                    color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            q.question,
            style: TextStyle(
              fontSize: 17,
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String letter, String text,
      {bool isCorrect = false, required bool isDark}) {
    final bool isSelected = _selectedOption == index;
    final bool showCorrectHighlight = _isAnswerChecked && isCorrect;
    final bool showWrongHighlight =
        _isAnswerChecked && isSelected && !isCorrect;

    Color borderColor = isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight;
    Color bgColor = isDark ? AppTheme.surface : AppTheme.lightSurface;
    Color letterBg = isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight;

    final correctColor = isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary;
    final wrongColor = isDark ? AppTheme.pinkAccent : Colors.red;

    if (showCorrectHighlight) {
      borderColor = correctColor;
      bgColor = correctColor.withValues(alpha: 0.1);
      letterBg = correctColor.withValues(alpha: 0.3);
    } else if (showWrongHighlight) {
      borderColor = wrongColor;
      bgColor = wrongColor.withValues(alpha: 0.1);
      letterBg = wrongColor.withValues(alpha: 0.3);
    } else if (isSelected && !_isAnswerChecked) {
      borderColor = _categoryColor;
      bgColor = _categoryColor.withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: borderColor,
              width: (showCorrectHighlight || showWrongHighlight) ? 2 : 1),
          boxShadow: showCorrectHighlight
              ? [BoxShadow(color: correctColor.withValues(alpha: 0.3), blurRadius: 10)]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: letterBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                    )),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            if (showCorrectHighlight)
              Icon(Icons.check_circle, color: correctColor),
            if (showWrongHighlight)
              Icon(Icons.cancel, color: wrongColor),
          ],
        ),
      ),
    );
  }

  void _showQuitDialog() {
    final isDark = _isDark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Quit Quiz?',
            style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary)),
        content: Text('Your progress will be lost. Are you sure?',
            style: TextStyle(
                color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CONTINUE',
                style: TextStyle(
                    color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text('QUIT',
                style: TextStyle(
                    color: isDark ? AppTheme.pinkAccent : Colors.red)),
          ),
        ],
      ),
    );
  }
}
