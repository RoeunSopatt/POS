import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/page/listtransaction/cashier/cashiersalesdetial.dart';

class SalesDetailPage extends StatefulWidget {
  const SalesDetailPage(
      {super.key,
      this.totalPrice,
      this.date,
      this.cashier,
      this.img,
      this.code,
      this.qty,
      this.name,
      this.recieptNum,
      this.id});
  final totalPrice;
  final date;
  final cashier;
  final img;
  final code;
  final qty;
  final name;
  final recieptNum;
  final id;

  @override
  State<SalesDetailPage> createState() => _SalesDetailPageState();
}

class _SalesDetailPageState extends State<SalesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "លេខវិក្ក័យប័ត្រ ",
              style: GoogleFonts.kantumruyPro(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "#${widget.recieptNum}",
              style: GoogleFonts.kantumruyPro(
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey, height: 1.0),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ការលក់សរុប",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${widget.totalPrice}",
                        style: GoogleFonts.kantumruyPro(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "កាលបរិច្ឆេទ",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.date.toString().toDateDividerStandardMPWT(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "អ្នកគិតលុយ",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.cashier}",
                            style: GoogleFonts.kantumruyPro(),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage("${widget.img}"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[200],
            ),
            DetailSale(
              saleId: widget.id,
            ),
           
          ],
        ),
      ),
    );
  }
}
