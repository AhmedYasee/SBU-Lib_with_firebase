import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Details extends StatelessWidget {
  Details ({
     required this.name,
     required this.desc,
     required this.image,
    required this.maxLines,
    super.key,
  });

  final String name , desc ;
  final String image ;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return
     Column( children: [
      Row (
            children: [
                Container( 
                   margin: const EdgeInsets.only(left: 1),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: 
               Image.asset( image  , width: 250 , height:300 ),
               ),
              
              Column (
              children: [ 
                        FittedBox( child: Text (name ,  
                       style: const TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 15,
                       color:Colors.black,   
            ),
             ),),
                  
            const  Padding(padding:EdgeInsets.all(55) ),
             RatingBar.builder(
   initialRating: 3,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 4,
   itemSize: 24,
   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => const Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
     print(rating);
   },
),
          ]
       ),]),
     
           Padding(padding: EdgeInsets.all(10)),

  Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.all(15),
            child:  Text(desc , 
                           maxLines: maxLines,
                           overflow: TextOverflow.ellipsis, style:const TextStyle(
                            color:Colors.black,
                            fontSize: 20
                           ), ),
          ),
          
          Container(
        margin: const EdgeInsets.all(25),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xff2c53b7),
          border: Border.all(
            width: 1,
            color: const Color(0xff2c53b7),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
         child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Book borrowing request           ',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.auto_stories,
              color: Colors.white,
            ),
          ],
        )),
      ],);
  }
}

  
