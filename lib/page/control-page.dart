// ignore_for_file: file_names
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:clue/page/chat-page.dart';
import 'package:clue/page/profile-page.dart';
import 'package:clue/page/search-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/style/color.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: kPad(context) * 0.23,
        width: double.infinity,
        decoration: BoxDecoration(
          color: scaffoldColor(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                AntIcons.messageOutlined,
                color: page == 0
                    ? shadowColor(context)
                    : shadowColor(context).withOpacity(0.2),
              ),
              onPressed: () {
                setState(() {
                  page = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.add,
                color: page == 1
                    ? shadowColor(context)
                    : shadowColor(context).withOpacity(0.2),
              ),
              onPressed: () {
                setState(() {
                  page = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.person,
                color: page == 2
                    ? shadowColor(context)
                    : shadowColor(context).withOpacity(0.2),
              ),
              onPressed: () {
                setState(() {
                  page = 2;
                });
              },
            ),
          ],
        ),
      ),
      body: page == 0
          ? ChatPage()
          : page == 1
              ? const SearchPage()
              : const ProfilePage(),
    );
  }
}
