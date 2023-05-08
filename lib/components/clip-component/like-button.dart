// // ignore_for_file: file_names
//
// import 'package:clue/constant/text-style.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class LikeButton extends StatefulWidget {
//   final void Function() pressed;
//   const LikeButton({Key? key, required this.pressed}) : super(key: key);
//
//   @override
//   State<LikeButton> createState() => _LikeButtonState();
// }
//
// class _LikeButtonState extends State<LikeButton> {
//   bool clicked = false;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           clicked = !clicked;
//         });
//         widget.pressed;
//       },
//       child: Column(
//         children: [
//           Icon(
//             CupertinoIcons.heart_solid,
//             color: clicked ? Colors.red : Colors.white.withOpacity(0.8),
//             size: 25,
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             clicked ? 'Liked!' : 'Like',
//             style: style(context)
//                 .copyWith(color: Colors.white.withOpacity(0.8), fontSize: 15),
//           )
//         ],
//       ),
//     );
//   }
// }
