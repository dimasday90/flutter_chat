import 'package:flutter/material.dart';

//* utils
import '../../utils/constants.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitHandler, this.isLoading);

  final void Function(
    BuildContext context,
    String email,
    String password,
    String username,
    AuthStatus status,
  ) submitHandler;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _status = AuthStatus.login;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitHandler(
        context,
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (_status == AuthStatus.signup)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return "Username must be at least 4 characters long";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return "Password must be at least 5 characters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.012,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _submit,
                      child: Text("Login"),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          if (_status == AuthStatus.login) {
                            _status = AuthStatus.signup;
                          } else {
                            _status = AuthStatus.login;
                          }
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        _status == AuthStatus.login
                            ? "Create new account"
                            : 'I already have an account',
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
