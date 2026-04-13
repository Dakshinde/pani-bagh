import 'package:flutter/material.dart';

class WaterTank extends StatelessWidget {
  final double percent;

  const WaterTank({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade900, width: 4),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // The Water
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 250 * (percent / 100),
                width: double.infinity,
                color: Colors.blue.shade400,
              ),
              // The Text
              Center(
                child: Text(
                  "${percent.toInt()}%",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}