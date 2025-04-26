import 'package:flutter/material.dart';

class HeightPickerPage extends StatefulWidget {
  const HeightPickerPage({super.key});

  @override
  State<HeightPickerPage> createState() => _HeightPickerPageState();
}

class _HeightPickerPageState extends State<HeightPickerPage> {
  FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: 45);
  int selectedHeight = 165;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const Text(
              'What Is Your Height?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Please select your height from the ruler below.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Selected Height
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  selectedHeight.toString(),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Cm',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Custom Ruler
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListWheelScrollView.useDelegate(
                      controller: scrollController,
                      itemExtent: 50,
                      perspective: 0.005,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHeight = 120 + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          int value = 120 + index;
                          if (value > 220) return null;
                          return Center(
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: value == selectedHeight ? 24 : 18,
                                fontWeight: value == selectedHeight ? FontWeight.bold : FontWeight.normal,
                                color: value == selectedHeight ? Colors.black : Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Yellow Line Indicator
                  Positioned(
                    right: 20,
                    child: Container(
                      width: 12,
                      height: 2,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Handle continue
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
