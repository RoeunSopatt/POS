import 'package:flutter/material.dart';

class SimpleStepper extends StatelessWidget {
  final int currentStep;

  SimpleStepper({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildStepper(),
      ),
    );
  }

  List<Widget> _buildStepper() {
    List<Widget> widgets = [];
    for (int i = 0; i < 3; i++) {
      // Add the step indicator
      widgets.add(_buildStep(i));

      // Add a line between steps if it's not the last step
      if (i < 2) {
        widgets.add(_buildLine(i));
      }
    }
    return widgets;
  }

  Widget _buildStep(int index) {
    bool isActive = index <= currentStep;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? Colors.teal : Colors.grey,
          child: Text(
            (index + 1).toString(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          ['មុីនុយ', 'កន្រ្តក', 'Checkout'][index], // Translated steps
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(int index) {
    bool isCompleted = index < currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin:const EdgeInsets.symmetric(horizontal: 8),
        color: isCompleted ? Colors.teal : Colors.grey,
      ),
    );
  }
}
