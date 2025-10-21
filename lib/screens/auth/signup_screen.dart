// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../services/auth_service.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_text_field.dart';
// import '../home_screen.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Passwords do not match'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     final authService = Provider.of<AuthService>(context, listen: false);

//     final success = await authService.signUp(
//       _emailController.text.trim(),
//       _passwordController.text,
//     );

//     if (success && mounted) {
//       _emailController.clear();
//       _passwordController.clear();
//       _confirmPasswordController.clear();

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//         (route) => false,
//       );
//     } else if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(authService.error),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 20),

//                 // App Logo
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2196F3),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF2196F3).withOpacity(0.3),
//                         blurRadius: 15,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.pets, size: 40, color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),

//                 Text(
//                   'Create Account',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800],
//                       ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Join PetTrack to help reunite pets with their families',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                         color: Colors.grey[600],
//                       ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),

//                 // Email
//                 CustomTextField(
//                   controller: _emailController,
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                   prefixIcon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Password
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                   prefixIcon: Icons.lock_outlined,
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() => _obscurePassword = !_obscurePassword);
//                     },
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Confirm Password
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   labelText: 'Confirm Password',
//                   hintText: 'Confirm your password',
//                   prefixIcon: Icons.lock_outlined,
//                   obscureText: _obscureConfirmPassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
//                     },
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),

//                 // Submit
//                 Consumer<AuthService>(
//                   builder: (context, authService, child) {
//                     return CustomButton(
//                       text: 'Create Account',
//                       onPressed: authService.isLoading ? null : _signUp,
//                       isLoading: authService.isLoading,
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 24),

//                 // Login link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account? ',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color: Colors.grey[600],
//                           ),
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Text(
//                         'Sign In',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               color: const Color(0xFF2196F3),
//                               fontWeight: FontWeight.w600,
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authService.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      body: SafeArea(
        child: isLargeScreen
            ? Row(
                children: [
                  // Left side - Image
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Right side - Form
                  Expanded(
                    flex: 5,
                    child: _buildFormSection(),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image
                    Container(
                      height: size.height * 0.35,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Form Section
                    _buildFormSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Community for Your',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[400],
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Register Your Canine\nCompanion Today',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.brown[800],
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Social buttons (non-functional, just for design)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(Icons.apple),
                const SizedBox(width: 16),
                _buildSocialButton(Icons.g_mobiledata, isGoogle: true),
                const SizedBox(width: 16),
                _buildSocialButton(Icons.facebook),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'or',
              style: TextStyle(
                color: Colors.brown[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Email
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8DDD0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.brown[700]),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.brown[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Password
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8DDD0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Colors.brown[700]),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.brown[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.brown[400],
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8DDD0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: TextStyle(color: Colors.brown[700]),
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: Colors.brown[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.brown[400],
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 32),

            // Sign Up Button
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4A2C2A),
                        Colors.brown[900]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: authService.isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: authService.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.brown[600],
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.brown[800],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, {bool isGoogle = false}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE8DDD0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.brown[600],
        size: isGoogle ? 40 : 28,
      ),
    );
  }
}