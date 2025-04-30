import 'package:flutter/material.dart';
import 'package:tracker/Screens/age.dart';

class GenderSelectionPage extends StatefulWidget {
  final Function(String)? onGenderSelected;
  final VoidCallback? onBackPressed;

  const GenderSelectionPage({
    super.key,
    this.onGenderSelected,
    this.onBackPressed,
  });

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage>
    with SingleTickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _navigateToAgeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgeSelectionPage(
          onAgeSelected: (age) {
            Navigator.pop(context, age);
          },
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
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
              // Back Button with custom design
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: GestureDetector(
                  onTap: widget.onBackPressed ?? () => Navigator.pop(context),
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

              // Header with enhanced design
              const Text(
                "What's Your\nGender?",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Info text with enhanced design
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
                  'Help us create a personalized experience for your fitness journey',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // Gender options in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderOption(
                    'male',
                    Icons.male,
                    'Male',
                    Colors.grey[200]!,
                    selectedBorderColor: Colors.yellow,
                  ),
                  _buildGenderOption(
                    'female',
                    Icons.female,
                    'Female',
                    Colors.grey[200]!,
                    selectedBorderColor: Colors.yellow,
                  ),
                ],
              ),

              const Spacer(),

              // Continue button with enhanced design
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: selectedGender != null
                        ? () {
                            if (widget.onGenderSelected != null) {
                              widget.onGenderSelected!(selectedGender!);
                            }
                            _navigateToAgeSelection();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender != null
                          ? Colors.black
                          : Colors.grey[300],
                      disabledBackgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selectedGender != null
                            ? Colors.white
                            : Colors.grey[600],
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

  Widget _buildGenderOption(
    String gender,
    IconData icon,
    String label,
    Color color, {
    Color? selectedBorderColor,
  }) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => _onGenderSelected(gender),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (selectedBorderColor ?? Colors.white)
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: isSelected ? 12 : 4,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 60,
                      color: isSelected ? Colors.yellow : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey[600],
                    fontSize: 20,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
