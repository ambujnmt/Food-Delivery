import 'package:flutter/material.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Testimonials Screen"),
      ),
    );
  }
}
