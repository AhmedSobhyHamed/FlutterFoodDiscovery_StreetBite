import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/email_form_field.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/password_form_field.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/validators/login_validator.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/login_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_show_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/login_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/login_status.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginValidator _validator = const LoginValidator();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // email form field
            EmailFormField(
              controller: _emailController,
              validator: (value) => _validator.validateEmail(value, context),
            ),
            const SizedBox(height: 16),

            // password form field
            PasswordFormField(
              controller: _passwordController,
              validator: (value) => _validator.validatePassword(value, context),
            ),

            SizedBox(height: 16),

            // go to signup page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LoginLocale.dontHaveAnAccount.getString(context)),
                TextButton(
                  onPressed: () {
                    context.read<AuthShowCubit>().showSignup();
                  },
                  child: Text(LoginLocale.signup.getString(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.yellow),),
                ),
              ],
            ),

            // login button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocConsumer<LoginCubit, loginStatus>(
                listener: (context, state) {
                  if (state is loginStatusSuccess) {
                    context.read<AuthBloc>().add(const becomeAthenticatedEvent());
                  }
                  if (state is loginStatusError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message.getString(context), style: TextStyle(color: Theme.of(context).colorScheme.error))),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is loginStatusLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.green,));
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenLight,
                      foregroundColor: AppColors.green,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<LoginCubit>().login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      LoginLocale.continueAction.getString(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ), // TextStyle
                    ), // ElevatedButton.styleFrom
                  ); // ElevatedButton;
                }, // builder
              ), // BlocConsumer
            ), // SizedBox
          ], // children
        ), // Column
      ), // Form
    ); // BlocProvider
  } // build
} // LoginForm

