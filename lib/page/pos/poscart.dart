import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/helper/font.dart';
import 'package:mobile/entity/model/order.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/page/pos/poscartreview.dart';
import 'package:mobile/page/pos/controller/cart_controller.dart';
import 'package:mobile/services/service_controller.dart';

class CartScreen extends StatefulWidget {
  final Map<Products, int> products;

  const CartScreen({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late DateTime currentDateTime;
  late String formattedDate;
  String cashierName =
      'Unknown Cashier'; // Add a variable to hold the cashier's name
  final ServiceController userController = Get.find<ServiceController>();
  Map<Products, bool> productClickState =
      {}; // Track the click state for products

  @override
  void initState() {
    super.initState();
    // Load the user's profile when the widget is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.load_user_profile_from_storage();
      setState(() {
        cashierName =
            userController.userprofile.value!.name ?? 'Unknown Cashier';
      });
    });

    // Get the current date and time
    currentDateTime = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);

    // Initialize the product click state
    widget.products.forEach((product, _) {
      productClickState[product] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "កន្រ្តក",
          style: GoogleFonts.kantumruyPro(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildCashierInfo(), // Display cashier info
          buildProductList(),
          buildCheckoutSection(),
        ],
      ),
    );
  }

  // Widget to display cashier information at the top
  Widget buildCashierInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "ការលក់សរុប:${widget.products.entries.fold(0, (sum, entry) => sum + (entry.key.unitPrice ?? 0) * entry.value).toDouble().toKhmerCurrency()}",
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'អ្នកគិតលុយ: $cashierName', // "Cashier: [cashierName]" in Khmer
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'កាលបរិច្ឆេទ: ${formattedDate.toDateDividerStandardMPWT()
            
            }', // "Date: [formattedDate]" in Khmer
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products.keys.elementAt(index);
          final quantity = widget.products[product]!;
          return buildCartItem(product, quantity, index);
        },
      ),
    );
  }

  Widget buildCartItem(Products product, int quantity, int index) {
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
              Image.network(product.image ?? '', width: 80, height: 80),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product.name}',style: GoogleFonts.kantumruyPro(),),
                  const SizedBox(height: 5),
                  Text('${product.code}',
                      style: GoogleFonts.kantumruyPro(fontSize: 12),),
                  const SizedBox(height: 5),
                  Text(product.unitPrice!.toDouble().toKhmerCurrency(),
                      style: GoogleFonts.kantumruyPro(color: Colors.green)),
                ],
              ),
              buildQuantitySelector(product, quantity),
              buildDeleteButton(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuantitySelector(Products product, int quantity) {
    return GestureDetector(
      onTap: () {
        setState(() {
          productClickState[product] =
              !productClickState[product]!; // Toggle the click state
        });
      },
      child: Container(
        width: 80,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: productClickState[product]!
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            widget.products[product] = quantity - 1;
                          } else {
                            widget.products.remove(product);
                            Get.find<CartController>().removeProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'អ្នកបានលុបផលិតផល'), // "Product removed" in Khmer
                              ),
                            );
                          }
                        });
                      },
                      child: const Icon(CupertinoIcons.minus)),
                  Text('$quantity'),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.products[product] = quantity + 1;
                        });
                      },
                      child: const Icon(CupertinoIcons.plus)),
                ],
              )
            : const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget buildDeleteButton(Products product) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        setState(() {
          Get.find<CartController>().removeProduct(product);
          widget.products.remove(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('អ្នកបានលុបផលិតផល'), // "Product removed" in Khmer
            ),
          );
        });
      },
    );
  }

  Widget buildCheckoutSection() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EText(
                text: 'សរុប',
                size: EFontSize.footer,
              ), // "Total" in Khmer
              Text(
                '${widget.products.entries.fold(0, (sum, entry) => sum + (entry.key.unitPrice ?? 0) * entry.value)}៛', // Total price calculation
                style: GoogleFonts.kantumruyPro(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartReview(
                      products: widget.products,
                      currentDateTime: formattedDate,
                      cashierName:
                          cashierName, // Pass the cashier name to CartReview
                    );
                  },
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF0C7EA5),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: EText(
                text: 'ពិនិត្យមុនពេលចេញ', // "Review before checkout" in Khmer
                size: EFontSize.footer,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
