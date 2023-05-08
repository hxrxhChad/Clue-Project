// ignore_for_file: use_build_context_synchronously, file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clue/page/control-page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/auth/auth.dart';
import '../service/style/color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List img = [
    'https://cdn.discordapp.com/attachments/1037389109313933312/1105075864133181572/DrawKit_Vector_Illustrations_Halloween_Illustrations_1.png',
    'https://cdn.discordapp.com/attachments/1037389109313933312/1105075864858804284/DrawKit_Vector_Illustrations_Halloween_Illustrations_4.png',
    'https://cdn.discordapp.com/attachments/1037389109313933312/1105075944529612870/DrawKit_Vector_Illustrations_Halloween_Illustrations_6.png',
    'https://cdn.discordapp.com/attachments/1037389109313933312/1105075945238450226/DrawKit_Vector_Illustrations_Halloween_Illustrations_9.png',
    'https://cdn.discordapp.com/attachments/1037389109313933312/1105075864372265020/DrawKit_Vector_Illustrations_Halloween_Illustrations_2.png'
  ];
  bool loading = false;
  int banner = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            flex: 5,
            child: CarouselSlider.builder(
              itemCount: img.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  height: kPad(context),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(img[index]), fit: BoxFit.cover),
                  ),
                );
              },
              options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  height: kPad(context),
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      banner = index;
                    });
                  }),
            )),
        Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(
                  left: kPad(context) * 0.1,
                  right: kPad(context) * 0.1,
                  bottom: kPad(context) * 0.1),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xff4b0062)),
                child: Padding(
                  padding: EdgeInsets.all(kPad(context) * 0.05),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              img.length,
                              (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: kPad(context) * 0.008,
                                        vertical: kPad(context) * 0.004),
                                    child: index == banner
                                        ? Container(
                                            width: kPad(context) * 0.025,
                                            height: kPad(context) * 0.008,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(
                                            width: kPad(context) * 0.008,
                                            height: kPad(context) * 0.008,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ))),
                      SizedBox(
                        height: kPad(context) * 0.05,
                      ),
                      Text(
                        'Sign in to get your Clue!, Enjoy.',
                        textAlign: TextAlign.center,
                        style: style(context).copyWith(
                            color: Colors.white,
                            fontSize: kPad(context) * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: kPad(context) * 0.05,
                      ),
                      Text(
                        'A fast and minimalist Chatting cum Social Media Application.',
                        textAlign: TextAlign.center,
                        style: style(context).copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(
                        height: kPad(context) * 0.1,
                      ),
                      InkWell(
                        onTap: () => login(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kPad(context) * 0.1,
                                vertical: kPad(context) * 0.05),
                            child: loading
                                ? SizedBox(
                                    height: kPad(context) * 0.05,
                                    width: kPad(context) * 0.05,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xff4b0062),
                                    ),
                                  )
                                : Text(
                                    'Get Started',
                                    style: style(context).copyWith(
                                        color: const Color(0xff4b0062),
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    ));
  }

  login() async {
    // loading
    setState(() => loading = true);

    // main operation
    try {
      await Auth().login().whenComplete(() async {
        if (await Auth().userExists()) {
          debugPrint('User Exists');
          //
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("email", Auth().auth.currentUser!.email.toString());
          //
          setState(() {
            loading = false;
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ControlPage()));
        } else {
          debugPrint("Don't Exists");
          await addUser(
              Auth().auth.currentUser?.displayName.toString(),
              Auth().auth.currentUser?.email.toString(),
              Auth().auth.currentUser?.photoURL.toString());
          //
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("email", Auth().auth.currentUser!.email.toString());
          //
          setState(() {
            loading = false;
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ControlPage()));
        }
      });
    } catch (e) {
      debugPrint('Faced Some Error :( ---> ${e.toString()}');
    }
  }
}
