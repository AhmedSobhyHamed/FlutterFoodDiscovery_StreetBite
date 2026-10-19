import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/add_button.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';

class FavItemPart extends StatelessWidget {
  const FavItemPart({super.key, required this.item});

  final FavItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            item.thumb,
            width: 84,
            height: 84,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 84,
              height: 84,
              color: AppColors.grayLight,
            ), // errorBuilder
          ), // Image.network
        ), // ClipRRect
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
                ), // Text
              ], // if
            ], // children
          ), // Column
        ), // Expanded
        AddButton(
          tooltip: CartLocale.add.getString(context),
          onPressed: () => context.read<CartCubit>().add(
            id: item.id,
            name: item.name,
            thumb: item.thumb,
            place: item.place,
          ),
        ),
      ], // children
    ); // Row
  } // build
} // FavItemPart
