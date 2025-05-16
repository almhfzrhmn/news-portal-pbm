import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'formlogin.dart';
import 'formregist.dart';
import 'main.dart';

// Constants
const _kButtonPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
const _kBorderRadius = BorderRadius.all(Radius.circular(10.0));
const _kBorder = BorderSide(color: Colors.blue, width: 3.0);
const _kToastDuration = Duration(seconds: 2);

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Future<String?> _loginFuture;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _loginFuture = getUsername();
    fToast = FToast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fToast.init(context); // Initialize FToast with context
  }

  Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('username');
    } catch (e) {
      fToast.showToast(
        toastDuration: _kToastDuration,
        child: const Text('Error accessing preferences'),
      );
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('token');
      fToast.showToast(
        toastDuration: _kToastDuration,
        child: const Text('Berhasil logout'),
      );
      // Reset navigation stack to ProfilPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyApp(initialPage: 0)),
        (route) => false,
      );
    } catch (e) {
      fToast.showToast(
        toastDuration: _kToastDuration,
        child: const Text('Error during logout'),
      );
    }
  }

  Widget _belumLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_circle,
          size: 150,
          color: Colors.blue,
          key: Key('profileIcon'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          key: const Key('loginButton'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: _kButtonPadding,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
          child: const Text('Masuk', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Belum memiliki akun? '),
            TextButton(
              key: const Key('registerButton'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegistPage()),
                );
              },
              child: const Text(
                'Create Account',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sudahLogin(String username) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_circle,
          size: 150,
          color: Colors.blue,
          key: Key('profileIconLoggedIn'),
        ),
        const SizedBox(height: 16.0),
        Container(
          key: const Key('usernameContainer'),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _kBorder.color, width: _kBorder.width),
            borderRadius: _kBorderRadius,
          ),
          child: Text(username, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 16.0),
        IconButton(
          key: const Key('logoutButton'),
          icon: const Icon(Icons.exit_to_app),
          color: Colors.blue,
          tooltip: 'Logout',
          onPressed: logOut,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: _loginFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final username = snapshot.data;
          return Center(
            child: username != null ? _sudahLogin(username) : _belumLogin(),
          );
        },
      ),
    );
  }
}
