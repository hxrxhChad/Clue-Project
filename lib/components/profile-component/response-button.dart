import 'package:flutter/material.dart';

import '../../service/style/color.dart';

class ResponseButton extends StatelessWidget {
  final IconData icon;
  final void Function() press;
  const ResponseButton({Key? key, required this.icon, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: kPad(context) * 0.08),
      child: InkWell(
        onTap: press,
        child: Material(
          elevation: 10,
          color: primaryColor(context),
          shadowColor: primaryColor(context).withOpacity(0.4),
          shape: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor(context),
            ),
            child: Padding(
              padding: EdgeInsets.all(kPad(context) * 0.03),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
