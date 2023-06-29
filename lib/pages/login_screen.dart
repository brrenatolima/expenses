import 'package:expenses/app_global_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../routes/routes_paths.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      //auth.createUserWithEmailAndPassword(email: email, password: password)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Usuário autenticado. Bem vindo ${auth.currentUser!.email}"),
        duration: Duration(seconds: 5),
        showCloseIcon: true,
      ));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed(RoutesPaths.HOME);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${err}"),
        duration: Duration(seconds: 10),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                key: AppGlobalKeys.inputEmailKey,
                decoration: const InputDecoration(labelText: "e-mail"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "senha"),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                            onPressed: () => {login()},
                            child: const Text("Login")),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () => {
                              Navigator.of(context).pushNamed(RoutesPaths.CREATE_ACCOUNT_SCREEN)
                            },
                            child: const Text("Não tem conta? Cadastre-se!")),
                      ],
                    )
            ],
          ),
        ),
    );
  }
}
