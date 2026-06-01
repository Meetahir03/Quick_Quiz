import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'services/user_data_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_data');
  final userService = UserDataService();
  await userService.init();
  runApp(QuickQuizApp(userService: userService));
}

class QuickQuizApp extends StatefulWidget {
  final UserDataService userService;
  const QuickQuizApp({super.key, required this.userService});

  @override
  State<QuickQuizApp> createState() => _QuickQuizAppState();
}

class _QuickQuizAppState extends State<QuickQuizApp> {
  @override
  void initState() {
    super.initState();
    widget.userService.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    widget.userService.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() {
    setState(() {}); // Rebuild when theme changes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickQuiz',
      debugShowCheckedModeBanner: false,
      theme: widget.userService.isDarkMode
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: SplashScreen(userService: widget.userService),
    );
  }
}
