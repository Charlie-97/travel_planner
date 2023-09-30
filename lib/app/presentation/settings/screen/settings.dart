import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_in.dart';
import 'package:travel_planner/app/presentation/settings/screen/edit_profile.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/data/model/conversation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),

            const SizedBox(height: 16.0),
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  // backgroundImage: AssetImage('assets/profile_image.jpg'), // Replace with your image
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('johndoe@example.com'),
                  ],
                )
              ],
            ),

            const SizedBox(height: 32.0),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              contentPadding: EdgeInsets.zero,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
              onTap: () {
                BaseNavigator.pushNamed(EditProfile.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment'),
              contentPadding: EdgeInsets.zero,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
              onTap: () {
                //BaseNavigator.pushNamed(EditProfile.routeName);
              },
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Log out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            // ListTile(
            //   leading: const Icon(Icons.security),
            //   title: const Text('Security'),
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   onTap: () {
            //     // Navigate to security settings
            //   },
            // ),
            // Add more settings as needed
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutDialog();
      },
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        'Are you sure you want to logout?',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      )),
      content: const Text(
        " Stay a while longer and continue your journey of discovery with us!",
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            BaseNavigator.pushNamedAndclear(SignInScreen.routeName);
            objectbox.store.box<ObjConversation>().removeAll();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
