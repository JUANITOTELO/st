import 'dart:io'
    show Platform; //Muestra en que plataforma movil se encuentra el codigo
import 'package:flutter/foundation.dart'
    show kIsWeb; //Muestra si el codigo se ve en un navegador
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:st/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServicioAutenticacion>(
          create: (_) => ServicioAutenticacion(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<ServicioAutenticacion>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Demo Autenticacion',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PaginaAuteunticacion(),
      ),
    );
  }
}

class PaginaAuteunticacion extends StatelessWidget {
  const PaginaAuteunticacion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebase_user = context.watch<User>();
    if (firebase_user != null) {
      return HomePage();
    }
    return SignInPage();
  }
}

class ServicioAutenticacion {
  final FirebaseAuth _auth;
  ServicioAutenticacion(this._auth);

  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In!";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<UserCredential> signInGoogle({String email, String password}) async {
    if (kIsWeb) {
      GoogleAuthProvider provider = GoogleAuthProvider();
      provider.setCustomParameters({'login_hint': 'user@example.com'});

      return await FirebaseAuth.instance.signInWithPopup(provider);
    }
    final GoogleSignInAccount user = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up!";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sign In Page"),
              campoRegistro(
                controller: emailController,
                title: "Email",
              ),
              campoRegistro(controller: passwordController, title: "Password"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServicioAutenticacion>().signIn(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    },
                    child: Text("Sign In"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<ServicioAutenticacion>().signUp(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      },
                      child: Text("Sign Up")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

TextField campoRegistro({TextEditingController controller, String title}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: title,
    ),
  );
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text("Loading App... :/"),
          ),
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text("UoOps... :("),
          ),
        ),
      ),
    );
  }
}
