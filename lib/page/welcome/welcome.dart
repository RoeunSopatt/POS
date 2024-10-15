import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/page/auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   height: MediaQuery.of(context).size.height * 0.2,
                      //   child: ImageFiltered(
                      //     imageFilter:
                      //         ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                      //     child: const Image(
                      //       image: AssetImage('asset/service.png'),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: const Image(
                            image: AssetImage('assets/images/cam.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
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
            ),
            Positioned(
              child: Column(
                children: [
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/logo/posmobile1.png'),
                                ),
                              ),
                            ),
                          ],
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0C7EA5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "សូមស្វាគមន៏",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "មកកាន់កម្មវិធីទូរស័ព្ទដៃនៃ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "ខេមហ្សាយប័រ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        Get.to(() => const Login());
                      },
                      child: Text(
                        "ចូលប្រើប្រាស់កម្មវិធី",
                        style: GoogleFonts.kantumruyPro(
                          color: Colors.white,
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}
