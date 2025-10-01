import 'package:flutter/material.dart';
import '../widgets/ui/button.dart';
import '../widgets/ui/input.dart';
import '../widgets/ui/label.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onNavigateToSignup;
  final VoidCallback onNavigateToForgotPassword;
  final VoidCallback onNavigateToAdminLogin;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onNavigateToSignup,
    required this.onNavigateToForgotPassword,
    required this.onNavigateToAdminLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Firebase Authentication would go here
    widget.onLogin();
  }

  void _handleGoogleLogin() {
    // Firebase Google Authentication would go here
    widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Logo & Title
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 40,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'PetTrack',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reuniting pets with their families',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Form
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sign in to continue',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Form
                          Column(
                            children: [
                              // Email Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(child: Text('Email')),
                                  const SizedBox(height: 8),
                                  Input(
                                    controller: _emailController,
                                    placeholder: 'your.email@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Password Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(child: Text('Password')),
                                  const SizedBox(height: 8),
                                  Input(
                                    controller: _passwordController,
                                    placeholder: '••••••••',
                                    obscureText: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomButton(
                                  onPressed: widget.onNavigateToForgotPassword,
                                  variant: ButtonVariant.ghost,
                                  child: Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Sign In Button
                              CustomButton(
                                onPressed: _handleSubmit,
                                child: Text('Sign In'),
                                fullWidth: true,
                                size: ButtonSize.large,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Google Login
                          CustomButton(
                            onPressed: _handleGoogleLogin,
                            variant: ButtonVariant.outline,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google icon SVG approximation
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/google.png'), // You'd add this asset
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text('Continue with Google'),
                              ],
                            ),
                            fullWidth: true,
                          ),
                          const SizedBox(height: 24),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              CustomButton(
                                onPressed: widget.onNavigateToSignup,
                                variant: ButtonVariant.ghost,
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Admin Login Link
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: widget.onNavigateToAdminLogin,
                  variant: ButtonVariant.ghost,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Admin Access',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}