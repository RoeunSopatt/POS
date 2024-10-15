import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:excellent_loading/excellent_loading.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/form.dart';
import 'package:mobile/entity/model/producttypesetup.dart';
import 'package:mobile/services/service_controller.dart';

class UpdateProduct extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String price;
  final String image;
  final String code;
  final String type;

  const UpdateProduct({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.image,
    required this.code,
    required this.type,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerType = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  final ServiceController service = ServiceController();
  final controller = FormInput();
  File? _image;
  List<DataSetUp> productTypes = []; // Holds fetched product types
  String? selectedTypeName; // Display selected product type
  int? selectedTypeId; // Holds selected product type ID

  @override
  void initState() {
    super.initState();
    _controllerName.text = widget.itemName;
    _controllerCode.text = widget.code;
    _controllerPrice.text = widget.price;
    _loadProductTypes(); // Load product types on initialization
  }

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
              title: Text(
                'ថតរូប',
                style: GoogleFonts.kantumruyPro(),
              ),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(
                'ជ្រើសរើសរូបភាព',
                style: GoogleFonts.kantumruyPro(),
              ),
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

  Future<void> _loadProductTypes() async {
    final productTypeSetUp = await service.fetchProductTypesSetUp();
    if (productTypeSetUp != null && productTypeSetUp.data != null) {
      setState(() {
        productTypes = productTypeSetUp.data!;
      });
    } else {
      UI.toast(text: 'Failed to load product types.');
    }
  }

  void _showProductTypeSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child: Container(
                  width: 120,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: productTypes.length,
                  itemBuilder: (context, index) {
                    final type = productTypes[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedTypeName = type.name;
                          selectedTypeId = type.id;
                          _controllerType.text = selectedTypeName!;
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        type.name ?? '',
                        style: GoogleFonts.kantumruyPro(),
                      ),
                      trailing: selectedTypeId == type.id
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
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

  void _handleSubmit() async {
    String productName = _controllerName.text.trim();
    String productCode = _controllerCode.text.trim();
    String productPrice = _controllerPrice.text.trim();
    String productType = selectedTypeId?.toString() ?? '';

    if (productName.isEmpty || productCode.isEmpty || productPrice.isEmpty) {
      UI.toast(text: 'សូមបញ្ចូលព័ត៌មានគ្រប់គ្រាន់', isSuccess: false);
      return;
    }

    String? imageBase64;
    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      imageBase64 = base64Encode(bytes);
    } else if (widget.image.isNotEmpty) {
      // Download and convert existing image to Base64
      try {
        final response = await http.get(Uri.parse(widget.image));
        if (response.statusCode == 200) {
          imageBase64 = base64Encode(response.bodyBytes);
        } else {
          UI.toast(text: 'Failed to load existing image', isSuccess: false);
          return; // Exit if the image cannot be loaded
        }
      } catch (e) {
        UI.toast(text: 'Error loading image: $e', isSuccess: false);
        return; // Exit on exception during image fetch
      }
    }

    try {
      ExcellentLoading.show(); // Show the loading indicator
      await service.updateProduct(
        productName,
        productCode,
        productType,
        productPrice,
        widget.itemId,
        imageBase64!, // Pass imageBase64, which may be null if not selected
      );
      // UI.toast(text: 'ប្រតិបត្តការជោគជ័យ'); // Success message
      Navigator.pop(context); // Navigate back after operation
    } catch (e) {
      print(e); // Print any errors to the console
      UI.toast(text: 'មានបញ្ហាមួយចំនួនកើតឡើង', isSuccess: false);
    } finally {
      ExcellentLoading.dismiss(); // Dismiss the loading indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.close)),
        backgroundColor: Colors.white,
        title: Text(
          'កែប្រែផលិតផល',
          style: GoogleFonts.kantumruyPro(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              'រួចរាល់',
              style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Card(
                          color: Colors.grey[200],
                          elevation: 0,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          //   side: BorderSide(color: Colors.grey.shade200),
                          // ),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 120,
                                child: Image.network(
                                  widget.image,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image,
                                        size: 80),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(Icons.camera_alt),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Card(
                          color: Colors.white,
                          elevation: 0,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          //   side: BorderSide(color: Colors.grey.shade200),
                          // ),
                          child: Stack(
                            children: [
                              Container(
                                width: 150,
                                height: 200,
                                child: Image.file(
                                  _image!,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(Icons.camera_alt),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: _controllerCode,
                  decoration: InputDecoration(
                    labelText: 'លេខកូដ *',
                    labelStyle: GoogleFonts.kantumruyPro(),
                    // border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: _controllerName,
                  decoration: InputDecoration(
                    labelText: 'ឈ្មោះ *',
                    labelStyle: GoogleFonts.kantumruyPro(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: _controllerPrice,
                  decoration: InputDecoration(
                    labelText: 'តម្លៃ(រៀល) *',
                    labelStyle: GoogleFonts.kantumruyPro(),
                    // border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: TextEditingController(
                      text: selectedTypeName ?? widget.type),
                  readOnly: true, // Make it read-only
                  onTap:
                      _showProductTypeSelectionBottomSheet, // Show bottom sheet
                  decoration: InputDecoration(
                    label: Text(
                      "ប្រភេទ​ *",
                      style: GoogleFonts.kantumruyPro(),
                    ),

                    labelStyle: GoogleFonts.kantumruyPro(),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    // border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
