import 'package:flutter/material.dart';

class SelectionBox extends StatelessWidget {
  final Rect rect;

  const SelectionBox({
    super.key,
    required this.rect,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: rect.left,
      top: rect.top,

      child: SizedBox(
        width: rect.width,
        height: rect.height,

        child: Stack(
          clipBehavior: Clip.none,

          children: [

            // Selection rectangle
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),



            // Top left resize handle
            const Positioned(
              left: -6,
              top: -6,
              child: HandleDot(),
            ),



            // Top right resize handle
            const Positioned(
              right: -6,
              top: -6,
              child: HandleDot(),
            ),



            // Bottom left resize handle
            const Positioned(
              left: -6,
              bottom: -6,
              child: HandleDot(),
            ),



            // Bottom right resize handle
            const Positioned(
              right: -6,
              bottom: -6,
              child: HandleDot(),
            ),



            // Center point
            const Positioned.fill(

              child: Center(
                child: HandleDot(
                  size: 12,
                ),
              ),
            ),




            // Rotation handle
            Positioned(

              top: -45,

              left: (rect.width / 2) - 6,

              child: Column(
                children: [

                  Container(
                    width: 2,
                    height: 35,

                    color: Colors.blue,
                  ),


                  const HandleDot(),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}



class HandleDot extends StatelessWidget {

  final double size;


  const HandleDot({
    super.key,
    this.size = 12,
  });



  @override
  Widget build(BuildContext context) {

    return Container(

      width: size,
      height: size,


      decoration: BoxDecoration(

        color: Colors.white,

        shape: BoxShape.circle,


        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),

      ),
    );
  }
}