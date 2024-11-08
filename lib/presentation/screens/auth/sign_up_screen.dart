import 'package:events_ticket/data/repositories/auth_repository.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final supabase = Supabase.instance.client;

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = false;
  String _errorMessage = AuthRepository().errorMessage ?? '';

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await AuthRepository().signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        _navigateToEntryPoint();
      } catch (e) {
        setState(() => _errorMessage = e.toString());
      } finally {
        setState(() => isLoading = false);
      }
      _clearFields();
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      await AuthRepository().signInWithGoogle();
      _navigateToEntryPoint();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => isLoading = true);
    try {
      await AuthRepository().signInWithApple();
      _navigateToEntryPoint();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _navigateToEntryPoint() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      ),
    );
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _fullNameController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Create Account",
                text: "Enter your Name, Email, and Password for sign up.",
              ),
              _buildSignUpForm(),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    text: "Already have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign In",
                        style: const TextStyle(color: Color(0xFF22A45D)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "By Signing up you agree to our Terms\nConditions & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Or",
                  style: TextStyle(
                      color: const Color(0xFF010F07).withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 16),
              SocialButton(
                press: _signInWithApple,
                text: "Connect with Apple",
                color: const Color(0xFF395998),
                icon: SvgPicture.asset(
                  'assets/icons/apple_box.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF395998),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SocialButton(
                press: _signInWithGoogle,
                text: "Connect with Google",
                color: const Color(0xFF4285F4),
                icon: SvgPicture.asset('assets/icons/google_box.svg'),
              ),
              const SizedBox(height: 16),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          TextFormField(
            controller: _fullNameController,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your full name'
                : null,
            decoration: const InputDecoration(
              hintText: "Full Name",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Email Field
          TextFormField(
            controller: _emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Email Address",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your password'
                : null,
            decoration: InputDecoration(
              hintText: "Password",
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF868686),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureText,
            textInputAction: TextInputAction.done,
            validator: (value) => value != _passwordController.text
                ? 'Passwords do not match'
                : null,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF3F2F2)),
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF868686),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ElevatedButton(
            onPressed: _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22A45D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16 / 2),
        Text(text, style: const TextStyle(color: Color(0xFF868686))),
        const SizedBox(height: 24),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final Color color;
  final String text;
  final Widget icon;
  final GestureTapCallback press;

  const SocialButton({
    super.key,
    required this.color,
    required this.icon,
    required this.press,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: press,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: icon,
            ),
            const Spacer(flex: 2),
            Text(
              text.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
