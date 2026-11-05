import 'package:clean_arch/features/home/presentation/blocs/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoggedOut) {
          context.go('/login');
        }

        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                tooltip: 'Log out',
                onPressed: state is HomeLoaded
                    ? () => context.read<HomeBloc>().add(
                  HomeLogoutRequested(),
                )
                    : null,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Center(
            child: state is HomeLoaded
                ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome, ${state.session.displayName}!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (state.session.mobile != null)
                    Text(state.session.mobile!),
                  if (state.session.cartId != null) ...[
                    const SizedBox(height: 8),
                    Text('Cart ID: ${state.session.cartId}'),
                  ],
                ],
              ),
            )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
