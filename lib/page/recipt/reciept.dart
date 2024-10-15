// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_font.dart';
// import 'package:mobile/entity/enum/e_variable.dart';
import 'package:mobile/entity/helper/font.dart';
import 'package:mobile/extension/extension_method.dart';

import 'package:mobile/page/pos/controller/cart_controller.dart';

class ReceiptWidget extends StatelessWidget {
  final double totalPrice;
  final String buyerName;
  final String receiptNumber;
  final String date;
  final List<ItemInfoData> items; // A list of items for the receipt

  const ReceiptWidget({
    super.key,
    required this.totalPrice,
    required this.buyerName,
    required this.receiptNumber,
    required this.date,
    required this.items, // Receive a list of items dynamically
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C7EA5),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              Text('រួចរាល់',style: GoogleFonts.kantumruyPro(fontSize: 18,),),
              const SizedBox(height: 40),
              receiptSummary(), // Dynamically updated with real data
              const SizedBox(height: 20),
              actionButtons(context, receiptNumber),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: confirmButton(context),
    );
  }

  Widget receiptSummary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.grey[500],
                ),
                Text(totalPrice.toDouble().toKhmerCurrency(),style: GoogleFonts.kantumruyPro(fontSize: 22,),)
              ],
            ),
            const SizedBox(height: 20),
            InfoRow(
              title: 'អ្នកគិតលុយ', // Cashier Name in Khmer
              value: buyerName, // Dynamic buyer name
            ),
            InfoRow(
              title: 'វិក្កយបត្រ', // Receipt number in Khmer
              value: receiptNumber, // Dynamic receipt number
            ),
            InfoRow(
              title: 'កាលបរិច្ឆេទ', // Date in Khmer
              value: date, // Dynamic date
            ),
            const Divider(),
            // Loop through the items dynamically
            for (var item in items)
              ItemInfo(
                name: item.name,
                quantity: 'x${item.quantity}',
                price: double.parse(item.price).toKhmerCurrency(),

                total:
    (item.quantity * double.parse(item.price)).toKhmerCurrency(),

              ),
          ],
        ),
      ),
    );
  }

  Widget actionButtons(BuildContext context, String orderId) {
    // final cartProvider = Get.find<CartController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withOpacity(0.5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.print, color: Colors.black),
            onPressed: () {
              // Implement print functionality here
            },
          ),
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withOpacity(0.5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.black),
            onPressed: () {
              // Implement print functionality here
            },
          ),
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withOpacity(0.5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Image(
              image: AssetImage('assets/images/share.png'),
            ),
            onPressed: () {
              // Implement print functionality here
            },
          ),
        ),
      ],
    );
  }

  Widget confirmButton(BuildContext context) {
    final cartProvider = Get.find<CartController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF0C7EA5),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () async {
            // Handle button tap here
            cartProvider.products.clear(); // Clear the cart
            Navigator.of(context)
                .popUntil((route) => route.isFirst); // Navigate back
          },
          child: EText(
            text: 'បញ្ជាទិញម្ដងទៀត', // "Order Again" in Khmer
            color: Colors.white,
            size: EFontSize.footer,
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
            ),
          ),
          Text(value, style: GoogleFonts.kantumruyPro(fontSize: 16)),
        ],
      ),
    );
  }
}

class ItemInfo extends StatelessWidget {
  final String name;
  final String quantity;
  final String price;
  final String total;

  const ItemInfo({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.kantumruyPro(fontSize: 16)),
              Text(price, style: GoogleFonts.kantumruyPro(fontSize: 16)),
            ],
          ),
          Column(
            children: [
              Text(quantity, style: GoogleFonts.kantumruyPro(fontSize: 16)),
              Text(total, style: GoogleFonts.kantumruyPro(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

// Data class for passing item information
class ItemInfoData {
  final String name;
  final int quantity;
  final String price;

  ItemInfoData({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
