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
        child: Form(
          child: AbsorbPointer(
            absorbing: _fetching,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Aplicación ganadería",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('login-email'),
                  onChanged: (value) {
                    setState(() {
                      _username = value.trim().toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
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
                  key: const Key('login-pass'),
                  onChanged: (value) {
                    setState(() {
                      _password = value.replaceAll(' ', '').toLowerCase();
                    });
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
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
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final isValid = Form.of(context).validate();
                        if (isValid) {
                          _submit(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.indigo.shade400, // Color de fondo
                        foregroundColor: Colors.white, // Color del texto
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                )
              ],
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
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
          arguments: user,
        );
      },
    );
  }
}
