import 'dart:async';
import 'package:events_ticket/data/repositories/auth_repository.dart';
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
  late final StreamSubscription<AuthState> _userSubscription;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // bool _redirecting = false;
  bool _obscureText = true;
  bool isLoading = false;
  String? errorMessage = '';

  // Initialisation de l'authentification à l'état
  @override
  void initState() {
    super.initState();
    _userSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        final session = data.session;
        if (session != null) {
          final userUuid = supabase.auth.currentUser?.id;
          if (userUuid != null) {
            debugPrint(
                "Session detected, initializing user with ID signUpScreen: $userUuid");
            if (mounted) {
              Navigator.of(context).popAndPushNamed(
                "/userInformation",
                arguments: userUuid,
              );
            }
          } else {
            debugPrint("User ID is null, redirecting failed.");
          }
        }
      },
      onError: (error) {
        if (mounted) {
          context.showSnackBar(error.message, isError: true);
          setState(() => errorMessage = error.message);
        }
      },
    );
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await AuthRepository().signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) _clearFields();
      } catch (e) {
        if (mounted) {
          setState(() => context.showSnackBar(e.toString(), isError: true));
        }
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      await AuthRepository().signInWithGoogle();
    } on AuthException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar(error.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
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
              _buildLoginLink(context),
              const SizedBox(height: 16),
              _buildPrivacyTerms(),
              const SizedBox(height: 16),
              _buildSocialSignInButtons(),
              if (isLoading) const Center(child: CircularProgressIndicator()),
              if (errorMessage!.isNotEmpty) _buildErrorText(),
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
          const SizedBox(height: 16),
          _buildTextField("Email Address", _emailController, (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          }, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildPasswordField("Password", _passwordController),
          const SizedBox(height: 16),
          _buildPasswordField("Confirm Password", _confirmPasswordController,
              confirm: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22A45D),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      String? Function(String?) validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF3F2F2)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF3F2F2)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller,
      {bool confirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (confirm && value != _passwordController.text) {
          debugPrint('Passwords do not match');
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF868686),
          ),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF3F2F2)),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Already have an account? ",
          children: [
            TextSpan(
              text: "Sign In",
              style: const TextStyle(color: Color(0xFF22A45D)),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyTerms() {
    return Center(
      child: Text(
        "By Signing up you agree to our Terms\nConditions & Privacy Policy.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        SocialButton(
          press: _signInWithGoogle,
          text: "Connect with Google",
          color: const Color(0xFF4285F4),
          icon: SvgPicture.asset('assets/icons/google_box.svg'),
        ),
      ],
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
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

extension ShowSnackBar on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
