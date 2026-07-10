import 'package:flutter/material.dart';

class ColourPickerScreen extends StatefulWidget {
  final Color initialColor;

  const ColourPickerScreen({
    super.key,
    this.initialColor = Colors.black,
  });

  @override
  State<ColourPickerScreen> createState() => _ColourPickerScreenState();
}

class _ColourPickerScreenState extends State<ColourPickerScreen> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Colour Picker",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              //==============================
              // Current Colour Preview
              //==============================

              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //==============================
              // Colour Picker Area
              //==============================

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Center(
                    child: Text(
                      "HSV Colour Picker\n(Coming in Part 2)",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //==============================
              // Hue Slider Placeholder
              //==============================

              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              const SizedBox(height: 16),

              //==============================
              // Opacity Slider Placeholder
              //==============================

              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          selectedColor,
                        );
                      },

                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}