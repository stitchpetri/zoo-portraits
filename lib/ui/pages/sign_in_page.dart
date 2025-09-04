import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  String? _msg;
  bool _sending = false;

  Future<void> _sendLink() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _sending = true;
      _msg = null;
    });

    try {
      // 👇 For web: redirect back to current origin (http://localhost:5173, etc.)
      final redirectUrl = kIsWeb ? Uri.base.origin : null;

      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectUrl,
      );

      setState(() {
        _msg = "Magic link sent to $email. Check your inbox!";
      });
    } on AuthException catch (e) {
      setState(() => _msg = e.message);
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sign in to Zoo Portraits",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sending ? null : _sendLink,
                  child: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Send magic link"),
                ),
                if (_msg != null) ...[
                  const SizedBox(height: 12),
                  Text(_msg!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
