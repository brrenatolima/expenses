
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../routes/routes_paths.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> createAccount() async {
    
    String email = emailController.text;
    String password = passwordController.text;

    try {
      //final user = await auth.signInWithEmailAndPassword(email: email, password: password);
      auth.createUserWithEmailAndPassword(email: email, password: password);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário cadastrado com sucesso!. Bem vindo ${auth.currentUser!.email}"), 
          duration: Duration(seconds: 5),)
      );
      Navigator.of(context).pushNamed(
                            RoutesPaths.LOGIN_SCREEN
                          );

    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${err}"), 
          duration: Duration(seconds: 10),)
      );
    }
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
              decoration: const InputDecoration(labelText: "e-mail"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "senha"),
            ),
            
            Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        createAccount()
                      }, 
                      child: const Text("Criar conta!")
                      ),
                      SizedBox(height: 20,),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                            RoutesPaths.LOGIN_SCREEN
                          );
                        }, 
                        child: Text("Já tem conta? Entre!")
                        ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}