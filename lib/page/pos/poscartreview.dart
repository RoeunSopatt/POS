import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/font.dart';
import 'package:mobile/entity/model/order.dart';
import 'package:mobile/extension/extension_method.dart';

import 'package:mobile/page/pos/controller/cart_controller.dart';
import 'package:mobile/page/recipt/reciept.dart';
import 'package:excellent_loading/excellent_loading.dart';

class CartReview extends StatefulWidget {
  const CartReview({
    Key? key,
    required this.products,
    required this.currentDateTime,
    required this.cashierName,
  }) : super(key: key);

  final Map<Products, int> products;
  final String currentDateTime;
  final String cashierName;

  @override
  _CartReviewState createState() => _CartReviewState();
}

class _CartReviewState extends State<CartReview> {
  int currentStep = 0;
  final CartController cartController =
      Get.find<CartController>(); // Using GetX
  Future<void> onConfirmOrder() async {
    ExcellentLoading.show();

    // Process the order using cartController
    await cartController.processOrder();
    cartController.products.clear(); // Clear the cart after processing

    // Check if the loading is done and order is successful
    if (!cartController.isLoading.value) {
      ExcellentLoading.dismiss();
      UI.toast(text: 'ប្រតិបត្តការជោគជ័យ'); // "Success" in Khmer
      // Navigate to the Receipt screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptWidget(
            totalPrice: cartController
                .totalPrice.value, // Total price from cartController
            buyerName:
                widget.cashierName, // Cashier name passed from CartScreen
            receiptNumber: cartController
                .receiptNumber.value, // Receipt number from cartController
            date: widget.currentDateTime, // Order creation date
            items: cartController
                .getItemList(), // List of items from cartController
          ),
        ),
      );
    } else {
      ExcellentLoading.dismiss();
      UI.toast(text: 'ប្រតិបត្តិការបរាជ័យ'); // "Failure" in Khmer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "ពិនិត្យមុនពេលចេញ",
          style: GoogleFonts.kantumruyPro(
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            buildSummaryHeader(),
            const SizedBox(height: 15),
            buildOrderInfo(),
            buildProductList(),
            const Divider(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: buildConfirmButton(),
    );
  }

  // Widget to build the header for order summary
  Widget buildSummaryHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: const BoxDecoration(color: const Color(0xFF0C7EA5)),
      alignment: Alignment.center,
      child: EText(
        color: Colors.white,
        text: 'សេចក្ដីសង្ខេបនៃការបញ្ជាទិញ', // "Order Summary" in Khmer
        size: EFontSize.content,
      ),
    );
  }

  // Widget to display order and cashier info
  Widget buildOrderInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('បង្កើតនៅ ៖​ ${widget.currentDateTime.toDateDividerStandardMPWT()}',style: GoogleFonts.kantumruyPro(fontSize: 14,),),
          const SizedBox(height: 15),
          Text('អ្នកគិតលុយ ៖​ ${widget.cashierName}',style: GoogleFonts.kantumruyPro(fontSize: 14,),),
        ],
      ),
    );
  }

  // Widget to build the list of products in the cart
  Widget buildProductList() {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products.keys.elementAt(index);
        final quantity = widget.products[product]!;
        return buildCartItem(product, quantity);
      },
    );
  }

  // Widget to display a single product in the cart
  Widget buildCartItem(Products product, int quantity) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product image and details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    product.image ?? '',
                    width: 40,
                    height: 80,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name!,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.code ?? '',
                        style: GoogleFonts.kantumruyPro(
                             fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.unitPrice!.toDouble().toKhmerCurrency(), // Display product price
                        style: GoogleFonts.kantumruyPro(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              // Quantity and total price per product
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("ចំនួន",style: GoogleFonts.kantumruyPro(),),
                        const SizedBox(width: 8),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C7EA5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text('$quantity',style: GoogleFonts.kantumruyPro(fontSize: 12,color: Colors.white,),)
                        ),
                      ],
                    ),
                    // Text("'${(product.unitPrice ?? 0) * quantity}៛'"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the confirm button
  Widget buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
         onTap: () async {
            await onConfirmOrder();
          },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF0C7EA5),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text('បញ្ជាក់',style: GoogleFonts.kantumruyPro(color: Colors.white,),),
        ),
      ),
    );
  }

  // Method to handle order confirmation
}
