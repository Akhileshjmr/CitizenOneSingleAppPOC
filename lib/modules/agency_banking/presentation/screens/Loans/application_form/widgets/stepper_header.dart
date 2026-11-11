import 'package:flutter/material.dart';

class StepperHeader extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Function(int) onStepSelected;

  const StepperHeader({
    Key? key,
    required this.currentStep,
    required this.steps,
    required this.onStepSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        bool isCompleted = index < currentStep;
        bool isActive = index == currentStep;

        return GestureDetector(
          onTap: () => onStepSelected(index),
          child: Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isCompleted
                        ? Colors.green
                        : isActive
                        ? Colors.orange
                        : Colors.grey.shade400,
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
              if (index != steps.length - 1)
                Container(
                  width: 40,
                  height: 2,
                  color: isCompleted ? Colors.green : Colors.grey.shade400,
                ),
            ],
          ),
        );
      }),
    );
  }
}
