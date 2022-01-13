import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/utilities/constants.dart';
import 'widgets/special_widgets/connectivity.dart';
// import 'package:first_app/user_screen.dart';

var _emailInput = '';
var _passwordInput = '';
var _rememberMe = false;

class SignIn extends StatefulWidget {
  static const screentitle = '/signintitle';
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  static const bool _isVisible = false;
  var _new = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  Future<void> _trySubmit(ctx, wanttoremember) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(ctx).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailInput.trim(), password: _passwordInput.trim());
        if (wanttoremember) {
          SharedPreferences.getInstance().then(
            (prefs) {
              prefs.setBool("remember_me", wanttoremember);
              prefs.setString('email', _emailInput);
              prefs.setString('password', _passwordInput);
              setState(() {
                _rememberMe = wanttoremember;
              });
            },
          );
        }
        final currentUser = FirebaseAuth.instance.currentUser;
        Navigator.pushReplacementNamed(ctx, UserScreen.screentitle,
            arguments: currentUser!.uid);
      } catch (err) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content:
                const Text('An error occured! Please, check your credentials!'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
    }
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      if (_remeberMe) {
        setState(() {
          _emailInput = _email;
          _passwordInput = _password;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildEmailTF(boolvalue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty || !value.contains('@supcom.tn')) {
                return 'Please enter a valid Email address!';
              }
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            initialValue: _rememberMe ? _emailInput : '',
            onSaved: (value) {
              _emailInput = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'The password field is empty!';
              }
              return null;
            },
            initialValue: _rememberMe ? _passwordInput : '',
            onSaved: (value) => _passwordInput = value!,
            obscureText: (_new == _isVisible),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _new = !_new;
                    });
                  },
                  icon: (_new == _isVisible)
                      ? const Icon(
                          Icons.remove_rounded,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        )),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: deeppurple,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(ctx) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          elevation: MaterialStateProperty.all<double>(5),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: () {
          _trySubmit(ctx, _rememberMe);
        },
        child: const Text(
          'LOGIN',
          style: loginStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    verifyConnection(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: decoration,
          ),
          Container(
            margin: const EdgeInsets.all(0),
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    _buildEmailTF(_rememberMe),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _buildRememberMeCheckbox(),
                    _buildLoginBtn(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
