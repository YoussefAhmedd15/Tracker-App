import 'package:flutter/material.dart';

class HeightPickerPage extends StatefulWidget {
  const HeightPickerPage({super.key});

  @override
  State<HeightPickerPage> createState() => _HeightPickerPageState();
}

class _HeightPickerPageState extends State<HeightPickerPage> {
  FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: 45);
  int selectedHeight = 165;

  double dragStartDy = 0.0;

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
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'What Is Your Height?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please select your height from the ruler below.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                selectedHeight.toString(),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Cm', style: TextStyle(fontSize: 20, color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xF3EDE7F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onVerticalDragStart: (details) {
                      dragStartDy = details.localPosition.dy;
                    },
                    onVerticalDragUpdate: (details) {
                      double dragDistance = details.localPosition.dy - dragStartDy;
                      if (dragDistance.abs() > 20) {
                        if (dragDistance > 0) {
                          if (selectedHeight > 120) {
                            setState(() {
                              selectedHeight--;
                              scrollController.jumpToItem(selectedHeight - 120);
                            });
                          }
                        } else {
                          if (selectedHeight < 220) {
                            setState(() {
                              selectedHeight++;
                              scrollController.jumpToItem(selectedHeight - 120);
                            });
                          }
                        }
                        dragStartDy = details.localPosition.dy;
                      }
                    },
                    child: ListWheelScrollView.useDelegate(
                      controller: scrollController,
                      itemExtent: 20,
                      physics: const FixedExtentScrollPhysics(),
                      perspective: 0.0001,
                      diameterRatio: 2.5,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHeight = 120 + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          int value = 120 + index;
                          if (value > 220) return null;

                          bool isMajor = value % 5 == 0;

                          return Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Container(
                                  height: 2,
                                  width: isMajor ? 20 : 10,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 8),
                                if (isMajor)
                                  Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Yellow Center Line
                Positioned(
                  right: 24,
                  child: Container(
                    width: 14,
                    height: 2,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // continue
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
