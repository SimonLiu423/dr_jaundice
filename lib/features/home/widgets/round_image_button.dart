import 'package:flutter/material.dart';

class RoundImageButton extends StatelessWidget {
  const RoundImageButton({
    super.key,
    required this.image,
    this.size = 120,
    this.onTap,
  });

  final String image;
  final double size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage(image),
          height: size,
          width: size,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
