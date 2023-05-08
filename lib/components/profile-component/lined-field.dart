import 'package:flutter/material.dart';

import '../../service/style/color.dart';

class LinedField extends StatelessWidget {
  final String hint;
  final String initialValue;
  final Function(String) onChanged;
  final String name;
  const LinedField(
      {Key? key,
      required this.hint,
      required this.name,
      required this.initialValue,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.08),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: style(context)
                  .copyWith(color: shadowColor(context).withOpacity(0.7)),
            ),
          ),
        ),
        SizedBox(
          width: kPad(context) * 0.85,
          child: TextFormField(
            onChanged: onChanged,
            showCursor: false,
            maxLines: null,
            initialValue: initialValue,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: style(context)
                    .copyWith(color: shadowColor(context).withOpacity(0.3)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.6))),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.6)))),
          ),
        ),
      ],
    );
  }
}
