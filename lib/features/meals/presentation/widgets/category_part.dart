import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';

class CategoryPart extends StatelessWidget {
  const CategoryPart({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final ValueChanged<CategoryEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.name == selectedCategory;
          return InkWell(
            onTap: () => onSelected(category),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? AppColors.green : Colors.transparent,
                        width: 2,
                      ), // Border.all
                    ), // BoxDecoration
                    child: Image.network(
                      category.thumb,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.restaurant,
                        color: AppColors.green,
                      ), // Icon
                    ), // Image.network
                  ), // Container
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ), // TextStyle
                  ), // Text
                ], // Column
              ), // Column
            ), // SizedBox
          ); // InkWell
        }, // itemBuilder
      ), // ListView.separated
    ); // SizedBox
  } // build
} // CategoryPart
