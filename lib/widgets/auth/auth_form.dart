import 'dart:io';
import 'package:flutter/material.dart';

//* utils
import '../../utils/constants.dart';

//* widgets
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitHandler, this.isLoading);

  final void Function(
    BuildContext context,
    String email,
    String password,
    String username,
    File image,
    AuthStatus status,
  ) submitHandler;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _status = AuthStatus.login;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  File _pickedImage;
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInCirc,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _pickImage(File image) {
    _pickedImage = image;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && _status == AuthStatus.signup) {
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitHandler(
        context,
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _pickedImage,
        _status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 1,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _status == AuthStatus.login
              ? size.height * 0.4
              : size.height * 0.77,
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight:
                          _status == AuthStatus.signup ? size.height * 0.25 : 0,
                      maxHeight:
                          _status == AuthStatus.signup ? size.height * 0.26 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInCirc,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: UserImagePicker(
                          imagePickerHandler: _pickImage,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
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
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _status == AuthStatus.signup ? 60 : 0,
                      maxHeight: _status == AuthStatus.signup ? 120 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInCirc,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          key: ValueKey('username'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
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
                      ),
                    ),
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
                      child: Text(
                        _status == AuthStatus.signup ? "Sign Up" : "Login",
                      ),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        setState(() {
                          if (_status == AuthStatus.login) {
                            _status = AuthStatus.signup;
                            _controller.forward();
                          } else {
                            _status = AuthStatus.login;
                            _controller.reverse();
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
