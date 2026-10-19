import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/l10n/fav_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/widgets/fav_item_part.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/l10n/main_controller_locale.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<FavCubit, favStatus>(
          builder: (context, state) {
            if (state is favStatusError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message.getString(context),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ), // Text
                    TextButton(
                      onPressed: () => context.read<FavCubit>().load(),
                      child: Text(FavLocale.retry.getString(context)),
                    ), // TextButton
                  ], // children
                ), // Column
              ); // Center
            } // favStatusError
            if (state is! favStatusLoaded) {
              return const Center(child: CircularProgressIndicator(color: AppColors.green));
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    MainControllerLocale.favorites.getString(context),
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
                  ), // Text
                ], // if (state.message != null) ...[
                const SizedBox(height: 24),
                if (state.items.isEmpty)
                  Text(
                    FavLocale.empty.getString(context),
                    style: const TextStyle(color: AppColors.grayDark, fontSize: 15),
                  ) // Text
                else
                  ...state.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: FavItemPart(item: item),
                    ), // Padding
                  ), // FavItemPart
              ], // ListView
            ); // ListView
          }, // builder
        ), // BlocBuilder
      ), // SafeArea
    ); // Scaffold
  } // build
} // FavPage
