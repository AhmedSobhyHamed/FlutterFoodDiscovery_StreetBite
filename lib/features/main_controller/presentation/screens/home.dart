import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          BlocProvider(
            create: (_) => getIt<SignOutCubit>(),
            child: BlocConsumer<SignOutCubit, signoutStatus>(
            listener: (context, state) {
              if (state is signoutStatusSuccess) {
                context.read<AuthBloc>().add(const becomeUnauthenticatedEvent());
              }
              if (state is signoutStatusError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.getString(context), style: TextStyle(color: Theme.of(context).colorScheme.error))),
                );
              }
            },
            builder: (context, state) {
              if (state is signoutStatusLoading) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                onPressed: () => context.read<SignOutCubit>().signOut(),
                icon: const Icon(Icons.logout),
              );
            },
            ),
          ),
        ],
      ),
    );
  }
}
