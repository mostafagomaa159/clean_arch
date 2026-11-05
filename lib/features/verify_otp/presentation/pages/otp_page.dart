import 'package:clean_arch/core/utils/validators.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_bloc.dart';
import 'package:clean_arch/features/verify_otp/presentation/blocs/otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    final bloc = context.read<VerifyOtpBloc>();
    final state = bloc.state;

    if (state is VerifyOtpLoading || state is VerifyOtpSuccess) return;

    final retryAuthentication =
        state is VerifyOtpFailure && state.accountActivated;

    // After activation, retry sign-in without validating the OTP again.
    if (!retryAuthentication &&
        !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    bloc.add(
      VerifyOtpSubmitted(_codeController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile =
        context.read<VerifyOtpBloc>().verificationContext.mobile;

    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          context.go('/home');
        }

        if (state is VerifyOtpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is VerifyOtpLoading;
        final retryAuthentication =
            state is VerifyOtpFailure && state.accountActivated;

        return PopScope(
          canPop: !loading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Verify OTP'),
              leading: IconButton(
                onPressed: loading
                    ? null
                    : () => context.go('/login'),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
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
                            'Verify your number',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Enter the code sent to $mobile.'),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _codeController,
                            enabled: !loading && !retryAuthentication,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [
                              AutofillHints.oneTimeCode,
                            ],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (retryAuthentication) return null;

                              return Validators.otp(value);
                            },
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              labelText: 'Verification code',
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
                                : Text(
                              retryAuthentication
                                  ? 'Retry sign in'
                                  : 'Verify',
                            ),
                          ),
                          if (state is VerifyOtpLoading) ...[
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (retryAuthentication) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Your account is activated. '
                                  'Retry to finish signing in.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
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
