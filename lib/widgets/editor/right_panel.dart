import 'package:flutter/material.dart';

class RightPanel extends StatelessWidget {

  final Widget child;

  const RightPanel({
    super.key,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      width: 70,

      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),


      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(16),


        border: Border.all(
          color: Colors.grey.shade300,
        ),


        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),

        ],
      ),


      child: child,

    );
  }
}