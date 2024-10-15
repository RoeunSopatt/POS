// import 'package:flutter/material.dart';
// import 'package:mobile/entity/enum/e_ui.dart';
// import 'package:mobile/entity/model/product.dart';

// class GridListView extends StatelessWidget {
//   final List<Product> items;
//   const GridListView({
//     super.key,
//     required this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       physics: const ClampingScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(
//               color: Colors.grey.withOpacity(0.1),
//               width: 2,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10),
//             ),
//           ),
//           child: Opacity(
//             opacity: 1,
//             child: TextButton(
//               onPressed: () {},
//               style: TextButton.styleFrom(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: const EdgeInsets.all(5),
//                   // backgroundColor: StyleColor.appBarDarkColor,
//                   backgroundColor: Colors.white),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   UI.cachedNetworkImage(
//                     url: items[index].image!,
//                     width: 70,
//                     height: 70,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(items[index].name ?? ""),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
