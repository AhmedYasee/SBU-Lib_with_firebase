import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/Addbook.dart';

class EditedBookCard extends StatelessWidget {
  const EditedBookCard({
    required this.name,
    super.key,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.black,
        color: Colors.white,
        child: SizedBox(
          width: 400,
          height: 170,
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.announcement_outlined,
                        size: 24,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddBook()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff2c53b7))),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddBook()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(240, 240, 5, 5))),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }
}
