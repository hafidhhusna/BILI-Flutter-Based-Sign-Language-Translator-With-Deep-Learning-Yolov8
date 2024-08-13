import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MicButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;

  const MicButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isPressed
              ? const Color.fromARGB(255, 40, 100, 140) // Darker color when pressed
              : const Color.fromARGB(255, 48, 117, 163), // Original color
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text
            Text(
              widget.text,
              style: GoogleFonts.montserrat(color: Colors.white),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
