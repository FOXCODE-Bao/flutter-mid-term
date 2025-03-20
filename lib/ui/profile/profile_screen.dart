import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mid_term/utils/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Profile")),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoButton(
                color: CupertinoColors.systemRed,
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  } on Exception catch (e) {
                    logError(e.toString());
                  }
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Email:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("${user!.email}", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
