// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
//
// import '../../constant/color-size.dart';
// import '../../constant/text-style.dart';
//
// class SheetText extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final void Function() press;
//   const SheetText(
//       {Key? key, required this.title, required this.icon, required this.press})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: press,
//       child: SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 35,
//             vertical: 15,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 color: shadowColor(context).withOpacity(0.5),
//               ),
//               const SizedBox(
//                 width: 25,
//               ),
//               Text(
//                 title,
//                 style: style(context).copyWith(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
