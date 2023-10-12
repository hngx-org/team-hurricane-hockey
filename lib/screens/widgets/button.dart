import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        shape: const BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: child),
      ),
    );
  }
}
