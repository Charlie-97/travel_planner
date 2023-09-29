import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_up.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/google_button.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/router/base_navigator.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "sign_in";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  bool obscurePassword = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool validateEmail({required String email}) {
    return ((email.contains('@') &&
            email.contains('.') &&
            (email.substring(email.length - 1) != '.' &&
                email.substring(email.length - 1) != '@'))) ||
        email.isEmpty;
  }

  bool checkPasswordLength(String password) {
    return password.length >= 8 || password.isEmpty;
  }

  Function setPasswordVisibility({required bool obscureText}) {
    return () {
      obscureText = !obscureText;
      return obscureText ? Icons.visibility : Icons.visibility_off;
    };
  }

  bool checkPasswordsMatch({
    required String password,
    required String passwordConfirmation,
  }) {
    return password == passwordConfirmation || passwordConfirmation.isEmpty;
  }

  @override
  void initState() {
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 100.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  focusNode: _emailFocus,
                  onEditingComplete: () {
                    _passwordFocus.requestFocus();
                  },
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: _userEmail,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@whatevermail.com',
                    prefixIcon: const Icon(Icons.mail),
                    prefixIconColor: Theme.of(context).colorScheme.onBackground,
                    errorText: validateEmail(email: _userEmail.text)
                        ? null
                        : 'Enter a valid email',
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  focusNode: _passwordFocus,
                  obscureText: obscurePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _userPassword,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    errorText: checkPasswordLength(_userPassword.text)
                        ? null
                        : 'Password must be at least 8 characters',
                    labelText: 'Password',
                    hintText: 'min. 8 characters',
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: Theme.of(context).colorScheme.onBackground,
                    suffixIconColor: Theme.of(context).colorScheme.onBackground,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          final toggleVisibility = setPasswordVisibility(
                              obscureText: obscurePassword);
                          obscurePassword = !obscurePassword;
                          final newIconData = toggleVisibility();
                          passwordVisibilityIcon = Icon(newIconData);
                        });
                      },
                      icon: passwordVisibilityIcon,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    BaseNavigator.pushNamedAndReplace(HomePage.routeName);
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          BaseNavigator.pushNamed(SignUpScreen.routeName);
                        },
                        child: Text(
                          "Sign up Here",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
