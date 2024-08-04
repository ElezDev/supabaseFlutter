import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:login/addTaskScreen.dart';
import 'package:login/onboardingScreen.dart';
import 'package:login/utils/styles.dart';
import 'package:login/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = client.auth.currentUser;
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];

    void _showLoadingDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible:
            false, // Impide que el usuario cierre el diálogo tocando fuera de él
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children:  <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Cerrando sesión...", style: smallitle(context)),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(fullName ?? 'Guest', style: smallitle(context)),
              accountEmail: Text(user?.email ?? 'Not logged in', style: smallitle(context)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title:  Text('Home', style: smallitle(context),),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          
            ListTile(
              leading: const Icon(Icons.logout),
              title:  Text('Cerrar sesión',  style: smallitle(context)),
              onTap: () async {
                _showLoadingDialog(context); // Muestra el diálogo de carga

                await Supabase.instance.client.auth.signOut();

                final googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                if (context.mounted) {
                  Navigator.of(context).pop(); // Cierra el diálogo de carga
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: AddTaskScreen(),
    );
  }
}
