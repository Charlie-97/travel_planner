import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/widgets/button.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/data/model/auth/user.dart';
import 'package:travel_planner/services/local_storage/shared_prefs.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const routeName = "edit_profile";
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _newEmail;
  late TextEditingController _newUserName;

  bool validateEmail({required String email}) {
    return ((email.contains('@') && email.contains('.') && (email.substring(email.length - 1) != '.' && email.substring(email.length - 1) != '@'))) ||
        email.isEmpty;
  }

  final storage = AppStorage.instance;

  ValueNotifier isLoading = ValueNotifier(false);

  late User user;
  @override
  void initState() {
    super.initState();
    final storeUser = storage.getUserData();
    if (storeUser != null) {
      user = storeUser;
      _newEmail = TextEditingController(text: user.email);
      _newUserName = TextEditingController(text: user.name);
    }
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
                  const SizedBox(height: 12.0),
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
            const SizedBox(height: 48)
          ],
        ),
      ),
    );
  }
}
