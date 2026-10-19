import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/widgets/cart_item_part.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/l10n/main_controller_locale.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<CartCubit, cartStatus>(
          builder: (context, state) {
            if (state is cartStatusError) {
              return _Message(
                text: state.message.getString(context),
                error: true,
                onRetry: () => context.read<CartCubit>().load(),
              );
            }
            if (state is! cartStatusLoaded) {
              return const Center(child: CircularProgressIndicator(color: AppColors.green));
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    MainControllerLocale.cart.getString(context),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ), // TextStyle
                  ), // Text
                ), // Padding
                if (state.message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.message!.getString(context),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 24),
                if (state.items.isEmpty)
                  Text(
                    CartLocale.empty.getString(context),
                    style: const TextStyle(color: AppColors.grayDark, fontSize: 15),
                  )
                else
                  ...state.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CartItemPart(
                        item: item,
                        onIncrease: () => context.read<CartCubit>().increase(item.id),
                        onDecrease: () => context.read<CartCubit>().decrease(item.id),
                        onRemove: () => context.read<CartCubit>().remove(item.id),
                      ), // Padding
                    ), // CartItemPart
                  ), // ListView.builder
              ], // ListView
            ); // ListView
          }, // builder
        ), // BlocBuilder
      ), // SafeArea
    ); // Scaffold
  } // build
} // CartPage

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.error, required this.onRetry});

  final String text;
  final bool error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: error ? Theme.of(context).colorScheme.error : AppColors.grayDark),
          ), // Text
          TextButton(
            onPressed: onRetry,
            child: Text(CartLocale.retry.getString(context)),
          ), // TextButton
        ], // children
      ), // Column
    ); // Center
  } // build
} // _Message
