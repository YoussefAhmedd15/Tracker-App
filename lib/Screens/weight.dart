import 'package:flutter/material.dart';

class WeightSelectionPage extends StatefulWidget {
  final Function(int)? onWeightSelected;
  final VoidCallback? onBackPressed;

  const WeightSelectionPage({
    super.key,
    this.onWeightSelected,
    this.onBackPressed,
  });

  @override
  State<WeightSelectionPage> createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  int selectedWeight = 75;
  final int minWeight = 40;
  final int maxWeight = 150;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeight(animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedWeight({bool animate = true}) {
    if (_scrollController.hasClients) {
      final itemExtent = 60.0;
      final offset = (selectedWeight - minWeight) * itemExtent;

      if (animate) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(offset);
      }
    }
  }

  void _updateSelectedWeight(int weight) {
    if (weight != selectedWeight &&
        weight >= minWeight &&
        weight <= maxWeight) {
      setState(() {
        selectedWeight = weight;
      });
      _scrollToSelectedWeight();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Header
              const Text(
                "What's Your\nWeight?",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Your weight helps us create a personalized fitness plan that is right for you',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Selected Weight Display
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.0,
                      ),
                      child: Text(
                        '$selectedWeight',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
                      child: Text(
                        'KG',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Triangle indicator
              Center(
                child: CustomPaint(
                  size: const Size(20, 16),
                  painter: TrianglePainter(color: Colors.yellow),
                ),
              ),

              const SizedBox(height: 10),

              // Weight selector
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Center Highlight
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          border: Border(
                            left: BorderSide(color: Colors.yellow, width: 2),
                            right: BorderSide(color: Colors.yellow, width: 2),
                          ),
                        ),
                      ),
                    ),

                    // Scrollable Weight Numbers
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification) {
                          final itemExtent = 60.0;
                          final selectedIndex =
                              (_scrollController.offset / itemExtent).round();
                          final newWeight = minWeight + selectedIndex;

                          if (newWeight >= minWeight &&
                              newWeight <= maxWeight) {
                            _updateSelectedWeight(newWeight);
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              (MediaQuery.of(context).size.width - 60) / 2,
                        ),
                        itemCount: maxWeight - minWeight + 1,
                        itemExtent: 60.0,
                        itemBuilder: (context, index) {
                          final weight = minWeight + index;
                          final isSelected = weight == selectedWeight;

                          return GestureDetector(
                            onTap: () => _updateSelectedWeight(weight),
                            child: Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: isSelected ? 24 : 18,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(weight.toString()),
                                    const SizedBox(width: 2),
                                    Text(
                                      'KG',
                                      style: TextStyle(
                                        fontSize: isSelected ? 12 : 10,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.onWeightSelected != null) {
                        widget.onWeightSelected!(selectedWeight);
                      }
                      Navigator.pop(context, selectedWeight);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => color != oldDelegate.color;
}
