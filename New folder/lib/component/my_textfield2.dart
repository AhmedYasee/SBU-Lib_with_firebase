import 'package:flutter/material.dart';

class MyTextField2 extends StatelessWidget {
  

  MyTextField2   ({
    super.key,
     required this.text,
     this.icon,
     this.suffixIcon,
     required this.obscure,
     required this.val, 
  });

   final String text;
   final bool obscure;
   final IconData? icon;
   final IconData? suffixIcon;
   final String val;
   
GlobalKey <FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {


   return Form (
    key: formstate,
    child:
      Column(
        children: [
          TextFormField(
            
            decoration: InputDecoration(
              hintText: text,
              prefixIcon: icon != null ? Icon(icon) : null,
            ),
            validator: (value) {
              if (value!.isEmpty){
                return (val);
              }
            },
          ),
        ],
      )
    );
  }
}
