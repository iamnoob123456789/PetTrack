import 'package:flutter/material.dart';
import '../widgets/ui/button.dart';
import '../widgets/ui/input.dart';
import '../widgets/ui/label.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onSignup;
  final VoidCallback onNavigateToLogin;

  const SignupScreen({
    super.key,
    required this.onSignup,
    required this.onNavigateToLogin,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      // Show error - in real app, use ToastService
      return;
    }

    // Firebase Authentication would go here
    widget.onSignup();
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
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomButton(
                    onPressed: widget.onNavigateToLogin,
                    variant: ButtonVariant.ghost,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 20),
                        const SizedBox(width: 8),
                        Text('Back to login'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Logo & Title
                Container(
                  padding: const EdgeInsets.only(bottom: 32),
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
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join our community of pet lovers',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Signup Form
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
                          // Form
                          Column(
                            children: [
                              // Name Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(child: Text('Full Name')),
                                  const SizedBox(height: 8),
                                  Input(
                                    controller: _nameController,
                                    placeholder: 'John Doe',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

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

                              // Phone Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(child: Text('Phone Number (Optional)')),
                                  const SizedBox(height: 8),
                                  Input(
                                    controller: _phoneController,
                                    placeholder: '+1 (555) 123-4567',
                                    keyboardType: TextInputType.phone,
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
                              const SizedBox(height: 16),

                              // Confirm Password Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(child: Text('Confirm Password')),
                                  const SizedBox(height: 8),
                                  Input(
                                    controller: _confirmPasswordController,
                                    placeholder: '••••••••',
                                    obscureText: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Create Account Button
                              CustomButton(
                                onPressed: _handleSubmit,
                                child: Text('Create Account'),
                                fullWidth: true,
                                size: ButtonSize.large,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              CustomButton(
                                onPressed: widget.onNavigateToLogin,
                                variant: ButtonVariant.ghost,
                                child: Text(
                                  'Sign in',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}