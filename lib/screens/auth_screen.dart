import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/constants.dart';
import 'package:sandwich_shop/repositories/auth_repository.dart';
import 'package:sandwich_shop/widgets/primary_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isRegistering = false;
  bool _isSubmitting = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isRegistering = !_isRegistering;
      _errorMessage = '';
    });
  }

  Future<void> _submitForm() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both an email and a password.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      if (_isRegistering) {
        await AuthRepository.instance.signUpWithEmail(email, password);
      } else {
        await AuthRepository.instance.signInWithEmail(email, password);
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = AuthRepository.instance.getErrorMessage(error);
        _isSubmitting = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Could not complete sign-in: $error';
        _isSubmitting = false;
      });
    }
  }

  Future<void> _signOut() async {
    await AuthRepository.instance.signOut();
    if (!mounted) {
      return;
    }
    setState(() {
      _isRegistering = false;
      _errorMessage = '';
    });
  }

  Widget _buildSignedInView(User currentUser) {
    String emailText = 'Signed-in account';
    final String? userEmail = currentUser.email;
    if (userEmail != null) {
      emailText = userEmail;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Account', style: shopSectionTitleStyle),
          const SizedBox(height: 16),
          Text('Signed in as $emailText'),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    String titleText = 'Customer Sign In';
    String buttonLabel = 'Sign In';
    String toggleLabel = 'Need an account? Register';
    if (_isRegistering) {
      titleText = 'Create Account';
      buttonLabel = 'Register';
      toggleLabel = 'Already have an account? Sign In';
    }

    final Widget actionWidget;
    if (_isSubmitting) {
      actionWidget = const CircularProgressIndicator();
    } else {
      actionWidget = PrimaryButton(
        label: buttonLabel,
        onPressed: _submitForm,
      );
    }

    Widget errorWidget = const SizedBox.shrink();
    if (_errorMessage.isNotEmpty) {
      errorWidget = Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText, style: shopSectionTitleStyle),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 16),
          errorWidget,
          actionWidget,
          const SizedBox(height: 8),
          TextButton(
            onPressed: _toggleMode,
            child: Text(toggleLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: shopHeaderStyle),
      ),
      body: StreamBuilder<User?>(
        stream: AuthRepository.instance.watchAuthState(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          final User? currentUser = snapshot.data;
          if (currentUser != null) {
            return _buildSignedInView(currentUser);
          }
          return _buildFormView();
        },
      ),
    );
  }
}
