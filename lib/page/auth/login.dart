

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mobile/page/auth/otp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showOtpForm = false;
  String _phoneNumber = '';
  
  void _showOtpInputForm(String phoneNumber) {
    setState(() {
      _showOtpForm = true;
      _phoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const HeaderWidget(),
            PositionWidget(
              onLogin: _showOtpInputForm,
              showOtpForm: _showOtpForm,
              phoneNumber: _phoneNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class PositionWidget extends StatelessWidget {
  final Function(String) onLogin;
  final bool showOtpForm;
  final String phoneNumber;

  const PositionWidget({
    super.key,
    required this.onLogin,
    required this.showOtpForm,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final phonekey = GlobalKey<FormState>();
  final phone = TextEditingController();

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 22,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Hero(
                        tag: 'hero-text',
                        createRectTween: (begin, end) {
                          return RectTween(begin: begin, end: end);
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'ប្រព័ន្ធគ្រប់គ្រងការលក់',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0C7EA5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  const SizedBox(
                    height: 35,
                    child: Image(
                      image: AssetImage('assets/images/cam.png'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Image(
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/smartphoneblack.png'),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "ចូលគណនីរបស់អ្នក",
              style: GoogleFonts.kantumruyPro(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: phonekey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'សូមបញ្ចូលលេខទូរស័ព្ទ';
                }
                // You can add additional validation if needed
                return null;
              },
              controller: phone,
              decoration: InputDecoration(
                label: Text(
                  'លេខទូរស័ព្ទ',
                  style: GoogleFonts.kantumruyPro(),
                ),
              ),
            ),
          ),
        ),
      ),
       SizedBox(height: MediaQuery.of(context).size.height * 0.24),

      Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              const Color(0xFF0C7EA5),
            ),
            fixedSize: WidgetStateProperty.all(
              const Size(400, 50),
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          onPressed: () {
            if (phonekey.currentState!.validate()) {
              Get.to(
                () => OtpInputForm(phone: phone.text),
               
              );
            } else {
              // Show error message
              null;
            }
          },
          // child: Obx(
          //   () => auth.isLoading.value
          //       ? const CircularProgressIndicator()
          //       : const Text(
          //           "បន្ទាប់",
          //           style: TextStyle(fontSize: 18, color: Colors.white),
          //         ),
          // ),
          child: Text(
            "បន្ទាប់",
            style: GoogleFonts.kantumruyPro(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    width: 117,
                    height: 1,
                    color: Colors.grey,
                  ),
                  Text(
                    ' ឬចុចចូលដោយស្វ័យប្រវត្តិ ',
                    style: GoogleFonts.kantumruyPro(color: Colors.black),
                  ),
                  Container(
                    width: 100,
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const SizedBox(
                      width: 170,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 22,
                            image: AssetImage('assets/images/account-star.png'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('អភិបាលប្រព័ន្ធ'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const SizedBox(
                      width: 170,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 22,
                            image: AssetImage('assets/images/account-cash.png'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('អ្នកគិតប្រាក់'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ជំនាន់​ 2.0.2',
                    style: GoogleFonts.kantumruyPro(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
            
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: const Opacity(
                opacity: 0.2,
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/Kbach.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
