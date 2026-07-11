import 'package:flutter/material.dart';

class RotateDeviceOverlay extends StatelessWidget {
  const RotateDeviceOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                Icons.screen_rotation,
                size: 90,
                color: Colors.pink,
              ),

              SizedBox(height: 30),

              Text(
                "Rotate Your Device",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              Text(
                "For the best editing experience,\nplease rotate your device to landscape mode.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}