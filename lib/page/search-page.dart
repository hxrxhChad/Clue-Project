// ignore_for_file: use_build_context_synchronously, file_names

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/page/profile-page.dart';
import 'package:clue/page/search-profile.dart';
import 'package:flutter/material.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/auth/auth.dart';
import '../service/style/color.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [blueC.withOpacity(0.2), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.center)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: kPad(context) * 0.15,
            ),
            Text(
              'Search',
              style: style(context).copyWith(
                  color: Colors.white,
                  fontSize: kPad(context) * 0.08,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: kPad(context) * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kPad(context) * 0.06,
                  vertical: kPad(context) * 0.02),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                    email = value;
                  });
                },
                textAlignVertical: TextAlignVertical.center,
                cursorColor: shadowColor(context).withOpacity(0.1),
                style: style(context).copyWith(
                    color: shadowColor(context), fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    AntIcons.searchOutlined,
                    color: shadowColor(context).withOpacity(0.3),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: shadowColor(context).withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: shadowColor(context).withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('user').snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: SizedBox(
                            height: 0,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (name.isEmpty) {
                              return const SizedBox(
                                height: 3,
                              );
                            }
                            if (data['displayName']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase()) ||
                                data['email']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(email.toLowerCase())) {
                              return InkWell(
                                splashColor:
                                    primaryColor(context).withOpacity(0.1),
                                onTap: () {
                                  if (data['docId'] == authId) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const ProfilePage()));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SearchProfile(
                                                    searchId: data['docId'])));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: kPad(context) * 0.06,
                                      right: kPad(context) * 0.08,
                                      top: kPad(context) * 0.05,
                                      bottom: kPad(context) * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: kPad(context) * 0.14,
                                            width: kPad(context) * 0.14,
                                            decoration: BoxDecoration(
                                                color: darkC,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        data['photoUrl']),
                                                    fit: BoxFit.cover)),
                                          ),
                                          SizedBox(
                                            width: kPad(context) * 0.025,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['displayName'],
                                                style: style(context).copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: kPad(context) * 0.4,
                                                child: Text(
                                                  data['bio'] == ""
                                                      ? ''
                                                      : data['bio'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: style(context)
                                                      .copyWith(
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.033,
                                                          color: shadowColor(
                                                                  context)
                                                              .withOpacity(
                                                                  0.5)),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            data['active'] ? 'Active Now' : '',
                                            style: style(context).copyWith(
                                                color: data['active']
                                                    ? Colors.green
                                                        .withOpacity(0.8)
                                                    : Colors.red
                                                        .withOpacity(0.8),
                                                fontSize:
                                                    kPad(context) * 0.023),
                                          ),
                                          SizedBox(
                                            height: kPad(context) * 0.023,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox(
                              height: 0,
                            );
                          });
                })
          ],
        ),
      ),
    );
  }
}
