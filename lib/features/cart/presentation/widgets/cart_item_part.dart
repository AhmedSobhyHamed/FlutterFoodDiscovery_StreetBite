import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';

class CartItemPart extends StatelessWidget {
  const CartItemPart({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItemEntity item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final canDecrease = item.quantity > CartItemEntity.minQuantity;
    final canIncrease = item.quantity < CartItemEntity.maxQuantity;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Thumb(url: item.thumb),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ), // TextStyle
              ), // Text
              if (item.place != null && item.place!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.place!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.grayDark, fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  _StepButton(
                    icon: Icons.remove,
                    enabled: canDecrease,
                    onPressed: onDecrease,
                  ), // _StepButton
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ), // TextStyle
                    ), // Text
                  ), // Padding
                  _StepButton(
                    icon: Icons.add,
                    enabled: canIncrease,
                    onPressed: onIncrease,
                  ), // _StepButton
                ], // children
              ), // Row
            ], // Column
          ), // Expanded
        ), // Padding
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline, color: AppColors.grayDark),
        ), // IconButton
      ], // children
    ); // Row
  } // build
} // CartItemPart

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 84,
          height: 84,
          color: AppColors.grayLight,
        ), // Container
      ), // ClipRRect
    ); // Image.network
  } // build
} // _Thumb

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, color: enabled ? AppColors.green : AppColors.grayMid),
    ); // IconButton
  } // build
} // _StepButton
