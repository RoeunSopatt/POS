import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';

import 'package:mobile/entity/model/user.dart';
import 'package:mobile/page/setting/crud/update.dart';
import 'package:mobile/page/setting/crud/updatepassword.dart';
import 'package:mobile/services/service_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ServiceController userController = Get.find<ServiceController>();
  final bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       userController.load_user_profile_from_storage();
  //     }
  //   });
  // }
  

  @override
  Widget build(BuildContext context) {
    final List<Icon> icon = [
      const Icon(Icons.edit),
      const Icon(Icons.lock_outline),
      const Icon(Icons.logout, color: Colors.red),
    ];
    final List<String> text = [
      'កែប្រែគណនី',
      'កែប្រែពាក្យសម្ងាត់',
      'ចាកចេញ',
    ];
    final List<Widget> page = [
      UpdateProfile(
        name: userController.userprofile.value!.name!,
        email: userController.userprofile.value!.email!,
        phone: userController.userprofile.value!.phone!,
        avatar: userController.userprofile.value!.avatar!,
      ),
      UpdatePasswordProfile(),
    ];

    return Obx(() {
      final userProfile = userController.userprofile.value;
      log('User after login and display on profile view: ${userProfile?.toJson() ?? 'null'}');

      if (userProfile == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      String avatarUrl = userProfile.avatar != null
          ? 'https://pos-v2-file.uat.camcyber.com/${userProfile.avatar!}'
          : 'assets/images/default-avatar.png';

      log('Avatar URL: $avatarUrl');

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  _showSettingsMenu(context, icon, text, page);
                },
                child: const Icon(Icons.more_horiz),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                backgroundImage: NetworkImage(avatarUrl),
                child: avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                userProfile.name ?? 'Unknown User',
                style: GoogleFonts.kantumruyPro(
                  fontSize: 24,
                ),
              ),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text("${userProfile.phone}"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text("${userProfile.email}"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: _buildRoleSelection(userProfile),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: UI.spinKit(),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRoleSelection(UserModel userProfile) {
    String getImageForRole(RoleUser role) {
      var roleImages = {
        1: 'account-star.png', // Admin
        2: 'account-cash.png', // Cashier
        // You can expand this list as per your role setup
      };
      return 'assets/images/${roleImages[role.id] ?? 'default.png'}';
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: userProfile.roles!.length,
      itemBuilder: (context, index) {
        final role = userProfile.roles![index];
        return ListTile(
          // onTap: () => changeDefaultRole(role),
          leading: Image(
            height: 22,
            image: AssetImage(getImageForRole(role)),
          ),
          title: Text(
            role.name ?? '',
            style: GoogleFonts.kantumruyPro(),
          ),
          trailing: role.isDefault!
              ? const Icon(Icons.check, color: Colors.green)
              : null,
        );
      },
    );
  }

  void _showSettingsMenu(
    BuildContext context,
    List<Icon> icon,
    List<String> text,
    List<Widget> page,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: icon.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: icon[index],
                    title: Text(
                      text[index],
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (index == 2) {
                        setState(() {
                          userController.logout();
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => page[index]),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // void changeDefaultRole(RoleUser selectedRole) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final userProfile = userController.userprofile.value;
  //   if (userProfile == null) {
  //     Get.snackbar("Error", "User profile not loaded.");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return;
  //   }

  //   userProfile.roles!
  //       .forEach((role) => role.isDefault = role.id == selectedRole.id);
  //   userController.saveUserProfileToStorage(userProfile);
  //   userController.setCurrentRole(selectedRole);

  //   Get.snackbar("Success", "Default role switched to ${selectedRole.name}");
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
