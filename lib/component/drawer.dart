// import 'package:flutter/material.dart';
// import 'package:mobile/entity/enum/e_font.dart';
// import 'package:mobile/entity/enum/e_variable.dart';
// import 'package:mobile/entity/helper/font.dart';
// import 'package:mobile/page/producttype/type.dart';
// import 'package:mobile/page/user/user.dart';

// class CustomDrawer extends StatelessWidget {
//   final VoidCallback onCloseDrawer;
//   const CustomDrawer({super.key, required this.onCloseDrawer});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color.fromARGB(255, 5, 10, 78),
//       child: ListView(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: onCloseDrawer,
//                   child: EText(
//                     text: 'X',
//                     color: Colors.white,
//                     size: EFontSize.extraLargePx,
//                     fontFamily: EFontFamily.englishBold,
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 65,
//                           child: Image.asset(
//                             'assets/logo/posmobile1.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           // UI.cachedNetworkImage(url: userPrefs.avatar!, width: 10, height: 20),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 35,
//               backgroundImage: NetworkImage("${userPrefs.avatar}"),
//             ),
//             title: EText(
//               text: '${userPrefs.name}',
//               color: Colors.white,
//               size: EFontSize.small,
//             ),
//             // subtitle: EText(
//             //   text: userPrefs.role!.name,
//             //   size: EFontSize.small,
//             //   color: Colors.white,
//             // ),
//             onTap: () {
//               // Navigation logic here
//             },
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.dashboard,
//               color: Colors.white,
//             ),
//             title: EText(
//               text: 'ផ្ទាំងព័ត៍មាន',
//               color: Colors.white,
//               size: EFontSize.small,
//             ),
//             onTap: () {
//               // Navigation logic here
//               onCloseDrawer();
//             },
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.shop,
//               color: Colors.white,
//             ),
//             title: EText(
//               text: 'ប្រភេទផលិតផល',
//               color: Colors.white,
//               size: EFontSize.small,
//             ),
//             onTap: () {
//               // Navigation logic here
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return const ProductType();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.person_pin_rounded,
//               color: Colors.white,
//             ),
//             title: EText(
//               text: 'អ្នកប្រើប្រាស់',
//               color: Colors.white,
//               size: EFontSize.small,
//             ),
//             onTap: () {
//               // Navigation logic here
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return UserList();
//                   },
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.info,
//               color: Colors.white,
//             ),
//             title: EText(
//               text: 'អំពីកម្មវិធី',
//               color: Colors.white,
//               size: EFontSize.small,
//             ),
//             onTap: () {
//               // Navigation logic here
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
