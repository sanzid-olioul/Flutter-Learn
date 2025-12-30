import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDebugPage extends StatefulWidget {
  @override
  State<FirebaseDebugPage> createState() => _FirebaseDebugPageState();
}

class _FirebaseDebugPageState extends State<FirebaseDebugPage> {
  String _debugInfo = 'Loading...';
  bool _authEnabled = false;
  bool _firestoreConnected = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseStatus();
  }

  Future<void> _checkFirebaseStatus() async {
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      String info = '';
      info += 'Firebase App: ${Firebase.apps.length} app(s) initialized\n\n';

      try {
        await auth.currentUser?.reload();
        setState(() => _authEnabled = true);
        info += '✓ Firebase Auth: Connected\n';
      } catch (e) {
        info += '✗ Firebase Auth: Error - $e\n';
      }

      try {
        await firestore.collection('death_notes').limit(1).get();
        setState(() => _firestoreConnected = true);
        info += '✓ Firestore: Connected\n';
      } catch (e) {
        info += '✗ Firestore: ${e.toString()}\n';
      }

      info += '\nTo fix issues:\n';
      if (!_authEnabled) {
        info +=
            '1. Enable Email/Password in Firebase Console > Authentication\n';
      }
      if (!_firestoreConnected) {
        info +=
            '2. Create Firestore Database in Firebase Console > Firestore\n';
        info += '3. Set to Test Mode (not Production)\n';
      }

      setState(() => _debugInfo = info);
    } catch (e) {
      setState(() => _debugInfo = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Debug')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _debugInfo,
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkFirebaseStatus,
                child: Text('Refresh Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
