import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/email_form_field.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/name_form_field.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/password_form_field.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/validators/signup_validator.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/login_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/signup_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_show_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signup_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signup_status.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignupValidator _validator = const SignupValidator();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignupCubit>(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // name form field
            NameFormField(
              controller: _nameController,
              validator: (value) => _validator.validateName(value, context),
            ),
            const SizedBox(height: 16),

            // email form field
            EmailFormField(
              controller: _emailController,
              validator: (value) => _validator.validateEmail(value, context),
            ),
            const SizedBox(height: 16),

            // password form field
            PasswordFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              validator: (value) => _validator.validatePassword(value, context),
            ),
            const SizedBox(height: 16),

            // confirm password form field
            PasswordFormField(
              controller: _confirmPasswordController,
              hint: SignupLocale.confirmPasswordHint.getString(context),
              validator: (value) => _validator.validateConfirmPassword(
                value,
                _passwordController.text,
                context,
              ),
            ),
            const SizedBox(height: 16),

            // go to login page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(SignupLocale.alreadyHaveAnAccount.getString(context)),
                TextButton(
                  onPressed: () {
                    context.read<AuthShowCubit>().showLogin();
                  },
                  child: Text(
                    SignupLocale.login.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.yellow,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // signup button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocConsumer<SignupCubit, signupStatus>(
                listener: (context, state) {
                  if (state is signupStatusSuccess) {
                    context.read<AuthBloc>().add(const becomeAthenticatedEvent());
                  }
                  if (state is signupStatusError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message.getString(context), style: TextStyle(color: Theme.of(context).colorScheme.error))),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is signupStatusLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    );
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
                        context.read<SignupCubit>().signup(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      SignupLocale.signupAction.getString(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ), // TextStyle
                    ), // Text
                  ); // ElevatedButton
                }, // builder
              ), // BlocConsumer
            ), // SizedBox
          ], // children
        ), // Column
      ), // Form
    ); // BlocProvider
  } // build
} // SignupForm
