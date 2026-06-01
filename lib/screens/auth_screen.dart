import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_data_service.dart';

class AuthScreen extends StatefulWidget {
  final UserDataService userService;
  final void Function(BuildContext) onAuthSuccess;

  const AuthScreen({
    super.key,
    required this.userService,
    required this.onAuthSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate brief network delay
    await Future.delayed(const Duration(milliseconds: 800));

    bool success;
    if (_isLogin) {
      success = await widget.userService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await widget.userService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      widget.onAuthSuccess(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin
              ? 'Invalid credentials. Please try again.'
              : 'Email already registered. Try logging in.'),
          backgroundColor: AppTheme.pinkAccent,
        ),
      );
    }
  }

  void _toggleMode() {
    _animController.reset();
    _animController.forward();
    setState(() {
      _isLogin = !_isLogin;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.userService.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.background : AppTheme.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      _buildLogo(isDark),
                      const SizedBox(height: 48),

                      // Title
                      Text(
                        _isLogin ? 'Welcome Back' : 'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin
                            ? 'Sign in to continue your journey'
                            : 'Start your quiz adventure today',
                        style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Name field (register only)
                      if (!_isLogin)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            icon: Icons.person_outline,
                            isDark: isDark,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Name is required' : null,
                          ),
                        ),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isDark: isDark,
                        obscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 4) return 'Minimum 4 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Submit button
                      _buildSubmitButton(isDark),
                      const SizedBox(height: 24),

                      // Toggle login/register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? "Don't have an account? " : "Already have an account? ",
                            style: TextStyle(
                              color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleMode,
                            child: Text(
                              _isLogin ? 'Register' : 'Login',
                              style: TextStyle(
                                color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Continue as Guest
                      _buildGuestButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 90,
      height: 90,
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
                .withValues(alpha: 0.3),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(Icons.flash_on, size: 45, color: Colors.white),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDark ? Colors.white : AppTheme.lightTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
        ),
        prefixIcon: Icon(icon,
            color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
            size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.pinkAccent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: isDark ? 8 : 3,
          shadowColor: (isDark ? AppTheme.cyanAccent : AppTheme.lightPrimary)
              .withValues(alpha: 0.4),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? Colors.black : Colors.white,
                ),
              )
            : Text(
                _isLogin ? 'SIGN IN' : 'CREATE ACCOUNT',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  Widget _buildGuestButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                await widget.userService.continueAsGuest();
                if (!mounted) return;
                setState(() => _isLoading = false);
                widget.onAuthSuccess(context);
              },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: isDark ? AppTheme.surfaceHighlight : AppTheme.lightSurfaceHighlight,
              width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          'CONTINUE AS GUEST',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
