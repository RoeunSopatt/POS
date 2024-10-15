import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/form.dart';
import 'package:mobile/services/service_controller.dart';

class UpdatePasswordProfile extends StatelessWidget {
  const UpdatePasswordProfile({super.key, this.id});
  final id;

  @override
  Widget build(BuildContext context) {
    final controller = FormInput();
    ServiceController service = ServiceController();
    //   void _handleSubmit() async {
    //   String confirmPass = controller.txtConpass.text.toString();

    //   if (confirmPass.isNotEmpty) {
    //     try {
    //       // Show loading indicator
    //       ExcellentLoading.show();

    //       // Call service to create product type
    //       var newProductType = await service.updatePassword();

    //       // Hide loading indicator
    //       ExcellentLoading.dismiss();

    //       // Show success toast
    //       UI.toast(text: 'ប្រតិបត្តការជោគជ័យ');

    //       // Navigate back and return the newly created product type
    //       Navigator.pop(context, newProductType);
    //     } catch (error) {
    //       // Handle error
    //       ExcellentLoading.dismiss();
    //       UI.toast(text: 'Error creating product type', isSuccess: false);
    //     }
    //   } else {
    //     UI.toast(text: 'សូមបញ្ចូលឈ្មោះប្រភេទផលិតផល', isSuccess: false);
    //   }
    // }
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
          "កែប្រែពាក្យសម្ងាត់",
          style: GoogleFonts.kantumruyPro(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final confirmPass = controller.txtConpass.text.trim();
              final pass = controller.txtPass.text.trim();
              if (controller.txtConpass.text.trim().isEmpty) {
                UI.toast(
                    text: 'សូមបញ្ចូលលេខសម្ងាត់គ្រប់គ្រាន់', isSuccess: false);
              } else {
                service.updatePasswordProfile(pass, confirmPass);
                UI.toast(text: "ការកែប្រែលេខសម្ងាត់ទទួលបានជោគជ័យ");
                Navigator.pop(context);
              }
            },
            child: const Text("រួចរាល់"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: controller.passkey,
                child: TextFormField(
                  controller: controller.txtPass,
                  decoration: InputDecoration(
                    label: Text(
                      "លេខសម្ងាត់",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ចូលលេខសម្ងាត់យ៉ាងតិច៦ខ្ទង់");
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
                key: controller.conpasskey,
                child: TextFormField(
                  controller: controller.txtConpass,
                  decoration: InputDecoration(
                    label: Text(
                      "បញ្ជាក់លេខសម្ងាត់",
                      style: GoogleFonts.kantumruyPro(),
                    ),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return ("សូមបញ្ជាក់ពាក្យសម្ងាត់");
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
