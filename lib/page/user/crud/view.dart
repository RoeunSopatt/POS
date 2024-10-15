import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/page/user/crud/updateuser.dart';
import 'package:mobile/page/user/crud/usercontroller.dart';

class ViewUser extends StatelessWidget {
  final UserController userController =
      Get.put(UserController()); // Inject the controller

  ViewUser({
    super.key,
    required String name,
    required String email,
    required String phoneNumber,
    required String date,
    required String role,
    required int userId,
    required String profilePic,
  }) {
    // Initialize the controller with the provided values
    userController.updateUser(
      updatedName: name,
      updatedEmail: email,
      updatedPhoneNumber: phoneNumber,
      updatedDate: date,
      updatedRole: role,
      updatedProfilePic: profilePic,
      updatedUserId: userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'មើលគណនី',
          style: GoogleFonts.kantumruyPro(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                // Navigate to UpdateUser and wait for results
                await Get.to(() => UpdateUser(
                      avatar: userController.profilePic.value,
                      email: userController.email.value,
                      name: userController.name.value,
                      phone: userController.phoneNumber.value,
                      roleID: 2, // Assuming roleId is passed
                      userID: userController.userId.value,
                      date: userController.date.value,
                    ));
              },
              child: const Image(
                height: 18,
                image: AssetImage('assets/images/edit.png'),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size(1, 2),
          child: Divider(),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 45,
                        backgroundImage:
                            NetworkImage(userController.profilePic.value),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        userController.name.value,
                        style: GoogleFonts.kantumruyPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${userController.role}",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_android_sharp),
                              const SizedBox(width: 8),
                              Text(
                                userController.phoneNumber.value,
                                style: GoogleFonts.kantumruyPro(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined),
                              const SizedBox(width: 8),
                              Text(
                                userController.email.value,
                                style: GoogleFonts.kantumruyPro(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(width: 8),
                              Text(
                                userController.date.value.toDateDMY(),
                                style: GoogleFonts.kantumruyPro(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
