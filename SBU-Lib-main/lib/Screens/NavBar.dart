import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/categorieslist.dart';
import 'package:fluttertest/Screens/categorieslistuser.dart';
import 'package:fluttertest/Screens/collegeslist.dart';
import 'package:fluttertest/Screens/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  String? selectedCollege;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localRole = prefs.getString('userRole');
    String? localCollege = prefs.getString('selectedCollege');
    String? localName = prefs.getString('firstname');
    String? localProfileImage = prefs.getString('profileImage');

    if (localRole != null && localCollege != null && localName != null) {
      // Use local data if available
      setState(() {
        userRole = localRole;
        selectedCollege = localCollege;
        userData = {
          'firstname': localName,
          'profile_image': localProfileImage,
        };
      });
    } else {
      // Fetch from Firebase if local data does not exist
      if (user != null) {
        try {
          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get();
          setState(() {
            userData = snapshot.data();
            selectedCollege = userData?['selected_college'] ?? 'Not selected';
            userRole = userData?['role'] ?? 'user';

            // Store data locally
            prefs.setString('userRole', userRole!);
            prefs.setString('selectedCollege', selectedCollege!);
            prefs.setString(
                'firstname', userData?['firstname'] ?? 'Loading...');
            prefs.setString('profileImage', userData?['profile_image'] ?? '');
          });
        } catch (e) {
          print('Error fetching user data: $e');
        }
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear cached user data on logout
    await prefs.clear();

    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
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
            ..._buildNavItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavItems() {
    if (userRole == 'admin') {
      return [
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
                  builder: (context) => CategoriesList(
                        selectedCollege: selectedCollege ?? '',
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
          leading: const Icon(Icons.feedback_outlined),
          title: const Text('Feedback',
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
          onTap: _logout,
        ),
      ];
    } else {
      return [
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
                  builder: (context) => CategoriesListUser(
                        selectedCollege: selectedCollege ?? '',
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
          title: const Text('Feedback',
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
          onTap: _logout,
        ),
      ];
    }
  }
}
