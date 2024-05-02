import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/NavBar.dart';
import 'package:fluttertest/component/my_textfield2.dart';
import 'package:fluttertest/component/my_textfield.dart';
import 'package:fluttertest/component/Colleges_Button.dart';

// ignore: camel_case_types
class CollegesList extends StatelessWidget {
  const CollegesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Categories List",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        drawer: const NavBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          // SizedBox(
          //   height: 34,
          // ),
          // Text(
          //   'Colleges Lists',
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          // ),

          MyTextField2(
            text: 'Search your college',
            icon: Icons.search,
            obscure: false,
            val: 'not valid!',
          ),

          const Colleges_Button(
              text:
                  'Faculty of Engineering \nShoubra Branch                                    '),
          const Colleges_Button(
              text: 'Faculty of medicine                             '),
          const SizedBox(height: 1),
          const Colleges_Button(
              text:
                  'Faculty of Commerce and \nBusiness Administration                    '),
          const Colleges_Button(
              text: 'Faculty of Law                                     '),
          const Colleges_Button(
              text: 'Faculty of Pharmacy                          '),
          const Colleges_Button(
              text: 'Faculty of Agriculture                        '),
          const Colleges_Button(
              text: 'Faculty of Education                          '),
          const Colleges_Button(
              text: 'Faculty of Arts                                    '),
          const Colleges_Button(
              text:
                  'Faculty of Computers \nand Information                                 '),
          const Colleges_Button(
              text: 'Faculty of Science                            '),
          const Colleges_Button(
              text:
                  'Faculty of Applied \nArts                                                    '),
          const Colleges_Button(
              text:
                  'Faculty of Special \nEducation                                         '),
          const Colleges_Button(
              text:
                  'Faculty of Physical \nEducation                                        '),
          const Colleges_Button(
              text:
                  'Faculty of Veterinary \nMedicine                                          '),
          const Colleges_Button(
              text: 'Faculty of Nursing                          '),
          const Colleges_Button(text: 'Faculty of Physiotherapy              '),
        ])));
  }
}
