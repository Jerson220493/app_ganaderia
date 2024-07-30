import 'package:flutter/material.dart';
import 'package:app_ganaderia/app/domain/enums.dart';
import 'package:app_ganaderia/main.dart';

import '../../../routes/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _username = '', _password = '';
  bool _fetching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      setState(() {
                        _username = value.trim().toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'username',
                    ),
                    validator: (value) {
                      value = value?.trim().toLowerCase() ?? '';
                      if (value.isEmpty) {
                        return 'Invalid user name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      setState(() {
                        _password = value.replaceAll(' ', '').toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    validator: (value) {
                      value = value?.replaceAll(' ', '').toLowerCase() ?? '';
                      if (value.length < 4) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Builder(
                    builder: (context) {
                      if (_fetching) {
                        return const CircularProgressIndicator();
                      }
                      return MaterialButton(
                        onPressed: () {
                          final isValid = Form.of(context)!.validate();
                          if (isValid) {
                            _submit(context);
                          }
                        },
                        color: Colors.blue,
                        child: const Text('Sign in'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });
    final result = await Injector.of(context)
        .authenticationRepository
        .signIn(_username, _password);

    if (!mounted) {
      return;
    }

    result.when(
      (failure) {
        setState(() {
          _fetching = false;
        });
        final message = {
          signInFailure.notFound: 'Not Found',
          signInFailure.unauthorized: 'Invalid password',
          signInFailure.unknown: 'Error',
        }[failure];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
      (user) {
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }
}
