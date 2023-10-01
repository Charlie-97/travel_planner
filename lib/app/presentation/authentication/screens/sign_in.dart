import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_up.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/button.dart';
import 'package:travel_planner/app/presentation/navigation.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/overlays/loader.dart';

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

  ValueNotifier isLoading = ValueNotifier(false);

  @override
  void initState() {
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, _) {
        return Stack(
          children: [
            Scaffold(
              // appBar: AppBar(
              //   title: Text(
              //     "Login Page",
              //     style: TextStyle(
              //       color: Theme.of(context).colorScheme.onPrimary,
              //     ),
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
                        const Text(
                          "Hi There! 👋",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "Gain secure access to your account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                            prefixIconColor:
                                Theme.of(context).colorScheme.onBackground,
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            errorText: validateEmail(email: _userEmail.text)
                                ? null
                                : 'Enter a valid email',
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                            errorText: checkPasswordLength(_userPassword.text)
                                ? null
                                : 'Password must be at least 8 characters',
                            hintText: 'min. 8 characters',
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 20,
                            ),
                            prefixIconColor:
                                Theme.of(context).colorScheme.onBackground,
                            suffixIconColor:
                                Theme.of(context).colorScheme.onBackground,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  final toggleVisibility =
                                      setPasswordVisibility(
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
                          height: 40.0,
                        ),
                        CustomButton(
                          onTap: () async {
                            isLoading.value = true;
                            await Future.delayed(
                                const Duration(milliseconds: 5000));
                            isLoading.value = false;
                            BaseNavigator.pushNamedAndclear(
                                Navigation.routeName);
                          },
                          title: 'Sign In',
                        ),
                        const SizedBox(
                          height: 15,
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
                                BaseNavigator.pushNamedAndReplace(
                                    SignUpScreen.routeName);
                              },
                              child: Text(
                                "Sign up Here",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (value) const Loader()
          ],
        );
      },
    );
  }
}
