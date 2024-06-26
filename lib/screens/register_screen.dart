import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/components/my_button.dart';
import 'package:per_rat/components/my_textfield.dart';
import 'package:per_rat/components/square_tile.dart';
import 'package:per_rat/screens/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == passwordConfirmController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        Navigator.pop(context);
        showErrorMessage('Passwords don\'t match!');
      }

      Navigator.of(context).maybePop();
    } on FirebaseAuthException catch (e) {
      //quit loading circle
      Navigator.maybePop(context);

      if (e.code == 'channel-error') {
        Navigator.pop(context);
        showErrorMessage('Please fill both login and password');
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white54,
        content: Text(message),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 152, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 169, 152, 55),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                'assets/logo.png',
                height: 150,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.src,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Let\'s create a new account!',
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: emailController,
                hintText: '${AutofillHints.username} or ${AutofillHints.email}',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordController,
                hintText: AutofillHints.password,
                obscureText: true,
              ),
              const SizedBox(
                height: 5,
              ),
              MyTextField(
                controller: passwordConfirmController,
                hintText: 'confirm password',
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                onTap: signUserUp,
                buttonText: 'Sign Up',
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.red.shade300,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Or continue with...',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'assets/sign_in/google.png',
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  SquareTile(
                    onTap: () {},
                    imagePath: 'assets/sign_in/apple.png',
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a cunt?'),
                  const SizedBox(
                    width: 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
