import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/bookslist.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/collegeslist.dart';
import 'package:fluttertest/Screens/feedback.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot<Map<String, dynamic>>? userData;
  String? selectedCollege;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();
        setState(() {
          userData = snapshot;
          selectedCollege =
              snapshot.data()?['selected_college'] ?? 'Not selected';
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: const Color.fromARGB(255, 11, 22, 50),
      child: Align(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userData?['firstname'] ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                selectedCollege ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: userData != null && userData!['profile_image'] != null
                      ? Image.network(
                          userData!['profile_image'],
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        )
                      : Image.asset(
                          'assets/images/default-user-icon-23.jpg',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesList(
                            selectedCollege: '',
                          )),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BooksList(
                            adminId: '',
                            categoryId: '',
                          )),
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
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
