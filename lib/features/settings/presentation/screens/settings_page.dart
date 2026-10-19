import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/di/injection.dart' as core;
import 'package:flutterfooddiscovery_streetbite/core/l10n/app_locale.dart';
import 'package:flutterfooddiscovery_streetbite/core/l10n/app_settings.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_theme.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/app_field_decoration.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/l10n/main_controller_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/l10n/profile_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/presentation/blocs/profile_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/presentation/blocs/profile_status.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var _filled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _fill(ProfileEntity profile) {
    if (_filled) return;
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _filled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, profileStatus>(
          builder: (context, state) {
            if (state is profileStatusError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message.getString(context),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ), // Text
                    TextButton(
                      onPressed: () => context.read<ProfileCubit>().load(),
                      child: Text(ProfileLocale.retry.getString(context)),
                    ), // TextButton
                  ], // children
                ), // Column
              ); // Center
            } // profileStatusError
            if (state is! profileStatusLoaded) {
              return const Center(child: CircularProgressIndicator(color: AppColors.green));
            }
            final profile = state.profile;
            _fill(profile);
            final image = _image(profile.image);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(
                  MainControllerLocale.settings.getString(context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ), // TextStyle
                ), // Text
                const SizedBox(height: 24),
                _section(MainControllerLocale.profile.getString(context)),
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    onTap: state.saving
                        ? null
                        : () => context.read<ProfileCubit>().pickImage(
                            name: _nameController.text,
                            email: _emailController.text,
                          ),
                    customBorder: const CircleBorder(),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.greenLight,
                      backgroundImage: image,
                      child: image == null
                          ? const Icon(Icons.person, color: AppColors.green, size: 42)
                          : null,
                    ), // CircleAvatar
                  ), // InkWell
                ), // Center
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.black, fontSize: 16),
                  decoration: appFieldDecoration(AppLocale.nameHint.getString(context)),
                ), // TextField
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.black, fontSize: 16),
                  decoration: appFieldDecoration(AppLocale.emailHint.getString(context)),
                ), // TextField
                if (state.message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.message!.getString(context),
                    style: TextStyle(
                      color: state.message == ProfileLocale.verifySent
                          ? AppColors.green
                          : Theme.of(context).colorScheme.error,
                    ), // TextStyle
                  ), // Text
                ], // if
                const SizedBox(height: 20),
                _ActionButton(
                  label: ProfileLocale.save.getString(context),
                  filled: true,
                  busy: state.saving,
                  onPressed: state.saving
                      ? null
                      : () => context.read<ProfileCubit>().save(
                          name: _nameController.text,
                          email: _emailController.text,
                        ),
                ), // _ActionButton
                const SizedBox(height: 12),
                _ActionButton(
                  label: (profile.emailVerified ? ProfileLocale.verified : ProfileLocale.verify)
                      .getString(context),
                  filled: false,
                  onPressed: profile.emailVerified || state.saving
                      ? null
                      : () => context.read<ProfileCubit>().verify(),
                ), // _ActionButton
                const SizedBox(height: 28),
                _section(MainControllerLocale.language.getString(context)),
                const SizedBox(height: 12),
                _ChoiceRow(
                  leftLabel: MainControllerLocale.english.getString(context),
                  rightLabel: MainControllerLocale.arabic.getString(context),
                  leftSelected: FlutterLocalization.instance.currentLocale?.languageCode != 'ar',
                  onLeft: () => AppSettings.setLanguage('en'),
                  onRight: () => AppSettings.setLanguage('ar'),
                ), // _ChoiceRow
                const SizedBox(height: 28),
                _section(MainControllerLocale.theme.getString(context)),
                const SizedBox(height: 12),
                _ChoiceRow(
                  leftLabel: MainControllerLocale.light.getString(context),
                  rightLabel: MainControllerLocale.dark.getString(context),
                  leftSelected: Theme.of(context).brightness == Brightness.light,
                  onLeft: () => AppSettings.setTheme(
                    AppTheme.light,
                    core.localDataSource,
                    core.getIt<ValueNotifier<ThemeData>>(),
                  ),
                  onRight: () => AppSettings.setTheme(
                    AppTheme.dark,
                    core.localDataSource,
                    core.getIt<ValueNotifier<ThemeData>>(),
                  ),
                ), // _ChoiceRow
                const SizedBox(height: 28),
                const _LogoutButton(),
              ], // children
            ); // ListView
          }, // builder
        ), // BlocBuilder
      ), // SafeArea
    ); // Scaffold
  } // build

  Widget _section(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  ImageProvider<Object>? _image(String path) {
    if (path.isEmpty) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    return FileImage(file);
  } // _image
} // _ProfileView

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final bool filled;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final child = busy
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
            strokeWidth: 2,
            color: filled ? AppColors.white : AppColors.green,
          ),
          ) // CircularProgressIndicator
        : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
    if (!filled) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.green,
            side: const BorderSide(color: AppColors.green),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ), // OutlinedButton.styleFrom
          onPressed: onPressed,
          child: child,
        ), // OutlinedButton
      ); // SizedBox
    }
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grayMid,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ), // ElevatedButton.styleFrom
        onPressed: onPressed,
        child: child,
      ), // ElevatedButton
    ); // SizedBox
  } // build
} // _ActionButton

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSelected,
    required this.onLeft,
    required this.onRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool leftSelected;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _choice(leftLabel, leftSelected, onLeft)),
        const SizedBox(width: 12),
        Expanded(child: _choice(rightLabel, !leftSelected, onRight)),
      ],
    );
  }

  Widget _choice(String label, bool selected, VoidCallback onPressed) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? AppColors.green : AppColors.white,
          foregroundColor: selected ? AppColors.white : AppColors.green,
          elevation: 0,
          side: const BorderSide(color: AppColors.green),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignOutCubit>(),
      child: BlocConsumer<SignOutCubit, signoutStatus>(
        listener: (context, state) {
          if (state is signoutStatusSuccess) {
            context.read<AuthBloc>().add(const becomeUnauthenticatedEvent());
            return;
          }
          if (state is signoutStatusError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(state.message.getString(context)),
              ),
            );
          }
        }, // listener
        builder: (context, state) {
          final loading = state is signoutStatusLoading;
          return _ActionButton(
            label: ProfileLocale.logout.getString(context),
            filled: false,
            busy: loading,
            onPressed: loading ? null : () => context.read<SignOutCubit>().signOut(),
          ); // _ActionButton
        }, // builder
      ), // BlocConsumer
    ); // BlocProvider
  } // build
} // _LogoutButton
