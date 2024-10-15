import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excellent_loading/excellent_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/font.dart';
import 'package:mobile/entity/helper/form.dart';
import 'package:mobile/services/service_controller.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({
    super.key,
  });

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final controller = FormInput();
  File? _image;

  // List of roles for selection
  final List<Map<String, dynamic>> roles = [
    {'id': 1, 'name': 'អ្នកគ្រប់គ្រង'},
    {'id': 2, 'name': 'អ្នកគិតលុយ'},
  ];
  final image = [
    'assets/images/account-star.png',
    'assets/images/account-cash.png',
  ];

  int? selectedRoleId;

  // Pick an image either from camera or gallery
  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: EText(
                text: 'ថតរូប',
                size: EFontSize.content,
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: EText(text: 'ជ្រើសរើសរូបភាព'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      final imageFile = await ImagePicker().pickImage(source: pickedFile);
      if (imageFile != null) {
        setState(() {
          _image = File(imageFile.path);
        });
      }
    }
  }

  void _showRoleSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedRoleId = role['id'];
                          controller.txt_code.text = role[
                              'name']; // Update the TextFormField with the selected role name
                        });
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      leading: Image(
                        height: 22,
                        image: AssetImage(
                          image[index],
                        ),
                      ),
                      title: Text(
                        role['name'],
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 14,
                        ),
                      ),
                      trailing: selectedRoleId == role['id']
                          ? const Icon(
                              Icons.check_box,
                              color: Color(0xFF0C7EA5),
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close)),
        title: Text(
          "បង្កើតអ្នកប្រើប្រាស់",
          style: GoogleFonts.kantumruyPro(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Text(
                "រួចរាល់",
                style: GoogleFonts.kantumruyPro(
                  color: const Color(0xFF0C7EA5),
                ),
              ),
              onPressed: () async {
                ExcellentLoading.show(); // Show the loading indicator

                if (controller.namekey.currentState!.validate() &&
                    controller.passkey.currentState!.validate() &&
                    controller.typekey.currentState!.validate() &&
                    selectedRoleId != null &&
                    _image != null) {
                  // Convert image to base64 string
                  final bytes = await _image!.readAsBytes();
                  String imageBase64 = base64Encode(bytes);
                  log('data:image/jpeg;base64,$imageBase64');

                  // Determine the role_ids to send based on selectedRoleId
                  List<int> roleIds;
                  if (selectedRoleId == 1) {
                    roleIds = [
                      1,
                      2
                    ]; // If role ID 1 is selected, send both 1 and 2
                  } else {
                    roleIds = [2]; // Otherwise, send only role ID 2
                  }

                  try {
                    // Call create user service with role_ids as a list
                    final service = ServiceController();
                    await service.createUser(
                      controller.txt_name.text.trim(),
                      roleIds, // Pass the roleIds list
                      controller.txt_price.text.trim(),
                      controller.txt_type.text.trim(),
                      controller.txtPass.text.trim(),
                      imageBase64,
                    );
                    log("${controller.txt_name.text.trim()}");
                  } catch (e) {
                    return;
                  } finally {
                    ExcellentLoading.dismiss(); // Dismiss the loading indicator
                    Navigator.pop(context);
                  }
                } else {
                  ExcellentLoading
                      .dismiss(); // Dismiss loading if validation fails
                  UI.toast(
                      text: 'ព័ត៌មានមិនពេញលេញ'); // Inform of validation failure
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Stack(
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage(
                            "assets/images/avatar.png",
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: FileImage(_image!),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            // Product Name Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.namekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 14,
                  ),
                  controller: controller.txt_name,
                  decoration: InputDecoration(
                    label: Text(
                      "ឈ្មោះ",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    // border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលឈ្មោះអ្នកប្រើប្រាស់");
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Role Selection (DropdownButtonFormField)
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.codekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(fontSize: 14),
                  controller: controller
                      .txt_code, // This is where the selected role will be displayed
                  readOnly: true,
                  onTap: () {
                    _showRoleSelectionBottomSheet(); // Call the function to show bottom sheet
                  },
                  decoration: InputDecoration(
                    label: Text(
                      "តួនាទី",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'សូមជ្រើសរើសតួនាទី';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Phone Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.pricekey,
                child: TextFormField(
                  controller: controller.txt_price,
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    label: Text(
                      "លេខទូរស័ព្ទ",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    // border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលលេខទូរស័ព្ទ");
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.passkey,
                child: TextFormField(
                  obscureText: true,
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 14,
                  ),
                  controller: controller.txtPass,
                  decoration: InputDecoration(
                    label: Text(
                      "លេខសម្ងាត់",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    // border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលលេខសម្ងាត់អ្នកប្រើប្រាស់");
                    }
                    return null;
                  },
                ),
              ),
            ),
            // Email Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.typekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 14,
                  ),
                  controller: controller.txt_type,
                  decoration: InputDecoration(
                    label: Text(
                      "អ៊ីម៉ែល",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    // border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលអ៊ីម៉ែល");
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
