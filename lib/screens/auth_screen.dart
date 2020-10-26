import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//* utils
import '../utils/constants.dart';

//* widgets
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitForm(
    BuildContext ctx,
    String email,
    String username,
    String password,
    AuthStatus status,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthResult authResult;
      if (status == AuthStatus.login) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          "email": email,
          "username": username,
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occurred, please check the credentials";
      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitForm,
        _isLoading,
      ),
    );
  }
}
