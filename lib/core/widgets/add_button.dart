import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.onPressed,
    this.label,
    this.tooltip,
    this.showLabel = false,
  });

  final VoidCallback onPressed;
  final String? label;
  final String? tooltip;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
          child: const Icon(Icons.add, color: AppColors.white, size: 22),
        ),
      );
    }
    return Material(
      color: AppColors.green,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label ?? '',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.add, color: AppColors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
