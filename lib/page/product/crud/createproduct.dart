import 'dart:convert';
import 'dart:io';
import 'package:excellent_loading/excellent_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/form.dart';
import 'package:mobile/entity/model/producttypesetup.dart';
import 'package:mobile/services/service_controller.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final controller = FormInput();
  File? _image;
  List<DataSetUp> productTypes = []; // Holds fetched product types
  String? selectedTypeName; // Display selected product type
  int? selectedTypeId; // Holds selected product type ID
  final ServiceController service = ServiceController();
  bool _isFormValid = false; // Track form validation status
  @override
  void initState() {
    super.initState();
    _loadProductTypes(); // Load product types on initialization
    _addFormListeners(); // Add listeners to the form fields
  }

  void _addFormListeners() {
    controller.txt_name.addListener(_validateForm);
    controller.txt_code.addListener(_validateForm);
    controller.txt_price.addListener(_validateForm);
    controller.txt_type.addListener(_validateForm);
  }

  // Validate the form fields
  void _validateForm() {
    final isValid = controller.namekey.currentState?.validate() == true &&
        controller.codekey.currentState?.validate() == true &&
        controller.pricekey.currentState?.validate() == true &&
        controller.typekey.currentState?.validate() == true &&
        _image != null && // Check if an image is selected
        selectedTypeId != null; // Check if a product type is selected

    // Update the button's visibility
    setState(() {
      _isFormValid = isValid;
    });
  }

  @override
  void dispose() {
    // Remove listeners to avoid memory leaks
    controller.txt_name.removeListener(_validateForm);
    controller.txt_code.removeListener(_validateForm);
    controller.txt_price.removeListener(_validateForm);
    controller.txt_type.removeListener(_validateForm);
    super.dispose();
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

  // Show the bottom sheet to select product type
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 130),
              //   child: Container(
              //     width: 120,
              //     height: 5,
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              // ),
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
                          controller.txt_type.text = selectedTypeName!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.close),
        ),
        title: Text(
          "បង្កើតផលិតផល",
          style: GoogleFonts.kantumruyPro(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // Conditionally show the button based on _isFormValid
          if (_isFormValid)
            IconButton(
              icon: Text(
                "រួចរាល់",
                style: GoogleFonts.kantumruyPro(
                  color: Colors.blue, // Button is visible only when valid
                ),
              ),
              onPressed: () async {
                ExcellentLoading.show(); // Show the loading indicator
                if (_isFormValid) {
                  // Convert image to base64 string
                  final bytes = await _image!.readAsBytes();
                  String imageBase64 = base64Encode(bytes);

                  try {
                    // Call create product service
                    await ServiceController.createProduct(
                      name: controller.txt_name.text,
                      code: controller.txt_code.text,
                      unitPrice: controller.txt_price.text,
                      typeId: selectedTypeId.toString(),
                      imageBase64: imageBase64,
                    );
                  } catch (e) {
                    UI.toast(text: 'បង្កើតផលិតផលបានបរាជ័យ');
                  } finally {
                    ExcellentLoading.dismiss();
                    Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Container(
                      color: Colors.grey[200],
                      width: 150,
                      height: 200,
                      // width: double.infinity,
                      child: Icon(Icons.add_a_photo, color: Colors.grey[800]),
                    )
                  : Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 150,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(15),
                          // ),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[400],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            // Product Name Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.namekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: controller.txt_name,
                  decoration: InputDecoration(
                    label: Text(
                      "ឈ្មោះផលិតផល",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលឈ្មោះផលិតផល");
                    }
                    return null;
                  },
                ),
              ),
            ),
            // Product Code Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.codekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: controller.txt_code,
                  decoration: InputDecoration(
                    label: Text(
                      "លេខកូដផលិតផល",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលលេខកូដផលិតផល");
                    }
                    return null;
                  },
                ),
              ),
            ),
            // Product Price Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.pricekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: controller.txt_price,
                  decoration: InputDecoration(
                    label: Text(
                      "តំលៃផលិតផល",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលតំលៃផលិតផល");
                    }
                    return null;
                  },
                ),
              ),
            ),
            // Product Type Input
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.typekey,
                child: TextFormField(
                  style: GoogleFonts.kantumruyPro(),
                  controller: controller.txt_type,
                  readOnly: true, // Make it read-only
                  onTap:
                      _showProductTypeSelectionBottomSheet, // Show bottom sheet
                  decoration: InputDecoration(
                    label: Text(
                      "ប្រភេទផលិតផល",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  validator: (value) {
                    if (selectedTypeName == null || selectedTypeName!.isEmpty) {
                      return ("សូមជ្រើសរើសប្រភេទផលិតផល");
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
