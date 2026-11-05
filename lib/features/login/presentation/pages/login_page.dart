import 'package:clean_arch/core/utils/validators.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_bloc.dart';
import 'package:clean_arch/features/login/presentation/blocs/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _submit() {
    if (context.read<LoginBloc>().state is LoginLoading) return;

    // Show field errors and stop if the input is invalid.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    context.read<LoginBloc>().add(
      LoginSubmitted(_mobileController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Replace Login so back navigation does not expose stale state.
          context.go(
            '/verify-otp',
            extra: state.verificationContext,
          );
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is LoginLoading;

        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Enter your mobile number',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Enter your mobile number',
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _mobileController,
                          enabled: !loading,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [
                            AutofillHints.telephoneNumber,
                          ],
                          validator: Validators.internationalMobile,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                            hintText: '+201012345678',
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (_) {
                            if (!loading) _submit();
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : const Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
