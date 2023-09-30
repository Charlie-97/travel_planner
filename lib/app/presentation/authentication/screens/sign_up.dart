import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_in.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/button.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/google_button.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/router/base_navigator.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "sign_up";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  late final TextEditingController _username;

  late final TextEditingController _userPasswordConfirmation;

  bool obscurePassword = true;

  bool obscurePasswordConfirmation = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);
  Icon confirmPasswordVisibilityIcon = const Icon(Icons.visibility);

  bool passwordsMatch = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();

  bool validateEmail({required String email}) {
    return ((email.contains('@') && email.contains('.') && (email.substring(email.length - 1) != '.' && email.substring(email.length - 1) != '@'))) ||
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
    _username = TextEditingController();
    _userPasswordConfirmation = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    _username.dispose();
    _userPasswordConfirmation.dispose();

    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        // appBar: AppBar(
        //   title: Text(
        //     'SignUp Page',
        //     style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        //   ),
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   centerTitle: true,
        //   elevation: 0.0,
        // ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 100.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Create your Account 😁",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "Create a secure account with us",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Full name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: _usernameFocus,
                    onEditingComplete: () {
                      _usernameFocus.requestFocus();
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    controller: _username,
                    onChanged: (_) {
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      // labelText: 'Email',
                      hintText: 'Mr travel planner',
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 20,
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.onBackground,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      // errorText: validateEmail(email: _userEmail.text) ? null : 'Enter your full name',
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
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
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      // labelText: 'Email',
                      hintText: 'example@whatevermail.com',
                      prefixIcon: const Icon(
                        Icons.mail,
                        size: 20,
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.onBackground,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      errorText: validateEmail(email: _userEmail.text) ? null : 'Enter a valid email',
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
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
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      errorText: checkPasswordLength(_userPassword.text) ? null : 'Password must be at least 8 characters',
                      hintText: 'min. 8 characters',
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 20,
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.onBackground,
                      suffixIconColor: Theme.of(context).colorScheme.onBackground,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            final toggleVisibility = setPasswordVisibility(obscureText: obscurePassword);
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
                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    focusNode: _confirmPasswordFocus,
                    obscureText: obscurePasswordConfirmation,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _userPasswordConfirmation,
                    onChanged: (_) {
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      errorText: checkPasswordsMatch(
                        password: _userPassword.text,
                        passwordConfirmation: _userPasswordConfirmation.text,
                      )
                          ? null
                          : '! Password Mismatch',
                      //  labelText: 'Confirm Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 20,
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.onBackground,
                      suffixIconColor: Theme.of(context).colorScheme.onBackground,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            final toggleConfirmVisibility = setPasswordVisibility(obscureText: obscurePasswordConfirmation);
                            obscurePasswordConfirmation = !obscurePasswordConfirmation;
                            final newIconData = toggleConfirmVisibility();
                            confirmPasswordVisibilityIcon = Icon(newIconData);
                          });
                        },
                        icon: confirmPasswordVisibilityIcon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    onTap: () {
                      BaseNavigator.pushNamedAndclear(HomePage.routeName);
                    },
                    title: "Sign up",
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5),
                      ),
                      SizedBox(width: 12),
                      Center(
                        child: Text(
                          'OR',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Divider(thickness: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const GoogleButton(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          BaseNavigator.pushNamedAndReplace(SignInScreen.routeName);
                        },
                        child: Text(
                          "Login Here",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
