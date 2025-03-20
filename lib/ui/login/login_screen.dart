import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mid_term/ui/home/home_screen.dart';
import 'package:mid_term/utils/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Login')),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoTextField(
              controller: _mailController,
              placeholder: 'Username',
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 16.0),
            CupertinoTextField(
              controller: _passwordController,
              placeholder: 'Password',
              obscureText: true,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 24.0),
            CupertinoButton.filled(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _mailController.text,
                    password: _passwordController.text,
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => MainScreen()),
                    );
                  });
                } on FirebaseAuthException catch (e) {
                  logError(e.code);
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
