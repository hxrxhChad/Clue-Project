import 'package:flutter/material.dart';

push(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

replace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}
