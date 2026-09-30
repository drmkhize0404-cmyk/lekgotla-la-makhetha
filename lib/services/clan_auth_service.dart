import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClanMemberUser {
  final String fullName;
  final String phone;
  final String branch;
  final bool isVerified;

  const ClanMemberUser({
    required this.fullName,
    required this.phone,
    required this.branch,
    this.isVerified = true,
  });
}

class ClanAuthService {
  static final ClanAuthService _instance = ClanAuthService._internal();
  factory ClanAuthService() => _instance;
  ClanAuthService._internal();

  ClanMemberUser? currentUser;
  static const String _userKey = 'clan_member_user_name';
  static const String _phoneKey = 'clan_member_user_phone';
  static const String _branchKey = 'clan_member_user_branch';

  Future<void> initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_userKey);
      final phone = prefs.getString(_phoneKey);
      final branch = prefs.getString(_branchKey);

      if (name != null && phone != null) {
        currentUser = ClanMemberUser(
          fullName: name,
          phone: phone,
          branch: branch ?? "Makhetha Family",
        );
      }
    } catch (_) {}
  }

  bool get isSignedIn => currentUser != null;

  Future<void> signIn({
    required String fullName,
    required String phone,
    required String branch,
  }) async {
    currentUser = ClanMemberUser(fullName: fullName, phone: phone, branch: branch);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, fullName);
      await prefs.setString(_phoneKey, phone);
      await prefs.setString(_branchKey, branch);
    } catch (_) {}
  }

  Future<void> signOut() async {
    currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_phoneKey);
      await prefs.remove(_branchKey);
    } catch (_) {}
  }

  /// 📍 SAFETY CHECK: Prompts sign-in before any business or financial transaction
  static void requireAuthentication(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String actionName = "complete this transaction",
  }) {
    final auth = ClanAuthService();
    if (auth.isSignedIn) {
      onAuthenticated();
      return;
    }

    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final branchC = TextEditingController(text: "Gauteng Branch");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.security_rounded, color: Color(0xFF10B981), size: 22),
            const SizedBox(width: 10),
            Text("Member Sign-In for Safety",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "For clan security, all ticket sales, escrow transactions, and contributions require verified identification to avoid fraud.",
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameC,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                decoration: const InputDecoration(labelText: "Full Name & Surname *", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneC,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                decoration: const InputDecoration(labelText: "WhatsApp / Cell Phone *", hintText: "082 123 4567", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: branchC,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                decoration: const InputDecoration(labelText: "Your Family Branch *", hintText: "e.g. Free State, Lesotho", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
                await auth.signIn(
                  fullName: nameC.text.trim(),
                  phone: phoneC.text.trim(),
                  branch: branchC.text.trim(),
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  onAuthenticated();
                }
              }
            },
            child: const Text("Sign In & Continue"),
          ),
        ],
      ),
    );
  }
}