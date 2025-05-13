import 'package:flutter/material.dart';
import 'common_layout.dart'; // Import the CommonLayout widget

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      body: Container(
        width: double.infinity, // Ensure the container takes full width
        height: MediaQuery.of(context).size.height, // Match the full height of the screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'Welcome to the About Page', // Corrected to "Home Page"
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Added color to improve text visibility
            ),
            textAlign: TextAlign.center, // Center the text horizontally
          ),
        ),
      ),
      selectedIndex: 3, // Index for "About" in the bottom navigation bar
    );
  }
}
