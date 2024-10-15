import 'package:excellent_loading/excellent_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_font.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/services/service_controller.dart';

class CreateTypeProduct extends StatefulWidget {
  const CreateTypeProduct({super.key});

  @override
  State<CreateTypeProduct> createState() => _CreateTypeProductState();
}

class _CreateTypeProductState extends State<CreateTypeProduct> {
  final TextEditingController _controller = TextEditingController();
  final ServiceController service = ServiceController();

  void _handleSubmit() async {
    String productName = _controller.text.toString();

    if (productName.isNotEmpty) {
      try {
        // Show loading indicator
        ExcellentLoading.show();

        // Call service to create product type
        var newProductType = await service.createProductType(productName);

        // Hide loading indicator
        ExcellentLoading.dismiss();

        // Show success toast
        UI.toast(text: 'ប្រតិបត្តការជោគជ័យ');

        // Navigate back and return the newly created product type
        Navigator.pop(context, newProductType);
      } catch (error) {
        // Handle error
        ExcellentLoading.dismiss();
        UI.toast(text: 'Error creating product type', isSuccess: false);
      }
    } else {
      UI.toast(text: 'សូមបញ្ចូលឈ្មោះប្រភេទផលិតផល', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        backgroundColor: Colors.white,
        title: EText(text: 'បង្កើតប្រភេទផលិតផល'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleSubmit,
            icon:  Text(
              "រួចរាល់",
              style: GoogleFonts.kantumruyPro(
                color: Colors.blue,
              ),
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
              decoration: const InputDecoration(
                labelText: 'ឈ្មោះ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
