// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:login/ProfileScreen.dart';
// import 'package:login/main.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   void initState() {
//     _setupAuthListener();
//     super.initState();
//   }

//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(),
//           ),
//         );
//       }
//     });
//   }

//   Future<AuthResponse> _googleSignIn() async {
//     const webClientId =
//         '480505900069-og0icd0umquo6vq2ntmfrhnletejnk1h.apps.googleusercontent.com';
//     const iosClientId = 'my-ios.apps.googleusercontent.com';
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       clientId: iosClientId,
//       serverClientId: webClientId,
//     );
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;

//     if (accessToken == null) {
//       throw 'No Access Token found.';
//     }
//     if (idToken == null) {
//       throw 'No ID Token found.';
//     }

//     return supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Imagen de onboarding
//             Image.asset(
//               'assets/images/elezdev.png',
//               width: 200,
//               height: 200,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Welcome to the App!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _googleSignIn,
//               child: const Text('Sign in with Google'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
