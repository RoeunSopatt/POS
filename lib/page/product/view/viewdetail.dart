import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/enum/e_variable.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/page/product/crud/updateproduct.dart';

class ViewDetailProduct extends StatelessWidget {
  final String images;
  final String name;
  final int price;
  final String type;
  final String code;
  final String date;
  final int id;
  const ViewDetailProduct(
      {super.key,
      required this.images,
      required this.name,
      required this.price,
      required this.type,
      required this.code,
      required this.date,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: EText(text: name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Card(
                    color: Colors.grey[200],
                    elevation: 0,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    //   side: BorderSide(color: Colors.grey.shade200),
                    // ),
                    child: Image.network(
                      height: mainHeight * 0.2,
                      images,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => UpdateProduct(
                                type: type,
                                image: images,
                                itemId: id,
                                itemName: name,
                                price: price.toString(),
                                code: code,
                              ),
                              transition: Transition.downToUp,
                              duration: const Duration(
                                milliseconds: 350,
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: Colors.white,
                elevation: 2,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10),
                //   side: BorderSide(color: Colors.grey.shade200),
                // ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.tag),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                code,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                name,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(Icons.dashboard_outlined),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                type,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 14,
                                  // color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(Icons.discount),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "$price៛",
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 14,
                                  // color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                (date).toDateDMY(),
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 14,
                                  // color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
