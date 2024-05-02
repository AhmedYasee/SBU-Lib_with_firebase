import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/bookslist.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/collegeslist.dart';
import 'package:fluttertest/Screens/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: const Color.fromARGB(255, 11, 22, 50),
      child: Align(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Ahmed Yassin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              accountEmail: const Text('Faculty of Engineering at shoubra',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  )),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Align(
                    child: Image.asset(
                      'assets/images/ahmed.jpeg',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xff2c53b7),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category_sharp),
              title: const Text('Categories',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {
                /// Close Navigation drawer before
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  CategoriesList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Books Lists',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {
                /// Close Navigation drawer before
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BooksList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_rounded),
              title: const Text('Colleges',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {
                /// Close Navigation drawer before
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CollegesList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_outlined),
              title: const Text('Suggestions',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text('Feed Back',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {
                /// Close Navigation drawer before
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedBack()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded),
              title: const Text('Support',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(53, 37, 85, 1))),
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
