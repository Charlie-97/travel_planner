import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/button.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/router/base_navigator.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const routeName = "edit_profile";
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //These old data would be replaced by actual user data
  final String? oldName = 'Tirioh';
  final String? oldEmail = 'Ab10dun@agbadevelopers.com';

  bool obscurePassword = true;

  bool obscurePasswordConfirmation = true;

  late TextEditingController _newEmail = TextEditingController(text: oldEmail);
  late TextEditingController _newUserName = TextEditingController(text: oldName);
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmNewPassword = TextEditingController();

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);
  Icon confirmPasswordVisibilityIcon = const Icon(Icons.visibility);

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
    _newEmail = TextEditingController();
    _newPassword = TextEditingController();
    _newUserName = TextEditingController();
    _confirmNewPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newEmail.dispose();
    _newUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "EDIT PROFILE",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // const SizedBox(
                  //   height: 24.0,
                  // ),
                  TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    controller: _newUserName,
                    onChanged: (_) {
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      // labelText: 'Email',
                      hintText: 'Enter New Name',
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
                  TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _newEmail,
                    onChanged: (_) {
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      // labelText: 'Email',
                      hintText: 'Enter New Email Address',
                      prefixIcon: const Icon(
                        Icons.email,
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
                      errorText: validateEmail(email: _newEmail.text) ? null : 'Enter a valid email address',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  // TextFormField(
                  //   obscureText: obscurePassword,
                  //   enableSuggestions: false,
                  //   autocorrect: false,
                  //   controller: _newPassword,
                  //   onChanged: (_) {
                  //     setState(() {});
                  //   },
                  //   onTapOutside: (event) {
                  //     FocusScope.of(context).unfocus();
                  //   },
                  //   decoration: InputDecoration(
                  //     errorText: checkPasswordLength(_newPassword.text)
                  //         ? null
                  //         : 'Password must be at least 8 characters',
                  //     hintText: 'min. 8 characters',
                  //     prefixIcon: const Icon(
                  //       Icons.lock,
                  //       size: 20,
                  //     ),
                  //     prefixIconColor:
                  //         Theme.of(context).colorScheme.onBackground,
                  //     suffixIconColor:
                  //         Theme.of(context).colorScheme.onBackground,
                  //     filled: true,
                  //     fillColor: Colors.grey.shade100,
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide:
                  //           BorderSide(color: Theme.of(context).primaryColor),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //     ),
                  //     focusedErrorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //     ),
                  //     suffixIcon: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           final toggleVisibility = setPasswordVisibility(
                  //               obscureText: obscurePassword);
                  //           obscurePassword = !obscurePassword;
                  //           final newIconData = toggleVisibility();
                  //           passwordVisibilityIcon = Icon(newIconData);
                  //         });
                  //       },
                  //       icon: passwordVisibilityIcon,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 12.0,
                  // ),
                  // TextFormField(
                  //   obscureText: obscurePasswordConfirmation,
                  //   enableSuggestions: false,
                  //   autocorrect: false,
                  //   controller: _confirmNewPassword,
                  //   onChanged: (_) {
                  //     setState(() {});
                  //   },
                  //   onTapOutside: (event) {
                  //     FocusScope.of(context).unfocus();
                  //   },
                  //   decoration: InputDecoration(
                  //     errorText: checkPasswordsMatch(
                  //       password: _newPassword.text,
                  //       passwordConfirmation: _confirmNewPassword.text,
                  //     )
                  //         ? null
                  //         : '! Password Mismatch',
                  //     hintText: 'Confirm password',
                  //     prefixIcon: const Icon(
                  //       Icons.lock,
                  //       size: 20,
                  //     ),
                  //     prefixIconColor:
                  //         Theme.of(context).colorScheme.onBackground,
                  //     suffixIconColor:
                  //         Theme.of(context).colorScheme.onBackground,
                  //     filled: true,
                  //     fillColor: Colors.grey.shade100,
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide:
                  //           BorderSide(color: Theme.of(context).primaryColor),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //     ),
                  //     focusedErrorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //     ),
                  //     suffixIcon: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           final toggleConfirmVisibility =
                  //               setPasswordVisibility(
                  //                   obscureText: obscurePasswordConfirmation);
                  //           obscurePasswordConfirmation =
                  //               !obscurePasswordConfirmation;
                  //           final newIconData = toggleConfirmVisibility();
                  //           confirmPasswordVisibilityIcon = Icon(newIconData);
                  //         });
                  //       },
                  //       icon: confirmPasswordVisibilityIcon,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                onTap: () {
                  BaseNavigator.pop();
                },
                title: "Save Changes",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
