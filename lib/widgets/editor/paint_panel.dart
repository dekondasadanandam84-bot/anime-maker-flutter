import 'package:flutter/material.dart';

class PaintPanel extends StatelessWidget {
final VoidCallback onClose;
  const PaintPanel({
    super.key,
    required this.onClose,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      body: SafeArea(

        child: Stack(

          children: [


            // Paint screen content
            const Center(
              child: Text(
                "Paint Screen",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),




            // CLOSE BUTTON
            Positioned(

              top: 20,

              right: 20,


              child: InkWell(

                borderRadius:
                    BorderRadius.circular(30),


                onTap: onClose, 


                child: Container(

                  width: 45,

                  height: 45,


                  decoration: BoxDecoration(

                    color: Colors.grey.shade200,

                    shape: BoxShape.circle,

                  ),


                  child: const Icon(

                    Icons.close,

                    size: 28,

                  ),

                ),

              ),

            ),


          ],

        ),

      ),

    );

  }

}