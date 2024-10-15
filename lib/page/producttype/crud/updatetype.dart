import 'package:excellent_loading/excellent_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';

import 'package:mobile/services/service_controller.dart';

class UpdateProductType extends StatefulWidget {
  final itemId;
  final itemName;
  const UpdateProductType({super.key, this.itemId, this.itemName});

  @override
  State<UpdateProductType> createState() => _UpdateProductTypeState();
}

class _UpdateProductTypeState extends State<UpdateProductType> {
  final TextEditingController _controller = TextEditingController();
  final ServiceController service = ServiceController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.itemName; // Initialize controller with itemName
  }

  void _handleSubmit() async {
    String productName = _controller.text;
    if (productName.isNotEmpty) {
      ExcellentLoading.show(); // Show the loading indicator
      try {
        await service.updateProductType(productName, widget.itemId);
        UI.toast(text: 'ប្រតិបត្តការជោគជ័យ'); // Success message
      } catch (e) {
        print(e); // Print any errors to the console
        UI.toast(
            text: 'មានបញ្ហាមួយចំនួនកើតឡើង',
            isSuccess: false); // Failure message
      } finally {
        ExcellentLoading.dismiss(); // Dismiss the loading indicator
        Navigator.pop(context); // Navigate back after operation
      }
    } else {
      UI.toast(
          text: 'សូមបញ្ចូលឈ្មោះប្រភេទផលិតផល',
          isSuccess: false); // Prompt to enter product name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close),
        ),
        title: Text(
          'កែប្រែប្រភេទផលិតផល',
          style: GoogleFonts.kantumruyPro(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              "រួចរាល់",
              style: GoogleFonts.kantumruyPro(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'ប្រភេទផលិតផល',
                labelStyle: GoogleFonts.kantumruyPro()
                // hintText: '${widget.itemName}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
