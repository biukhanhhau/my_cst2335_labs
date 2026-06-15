import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Lab4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  var imageSource = "images/question-mark.png";

  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    String savedLogin = await _prefs.getString('login_name');
    String savedPassword = await _prefs.getString('password');

    if (savedLogin.isNotEmpty && savedPassword.isNotEmpty) {
      setState(() {
        _loginController.text = savedLogin;
        _passwordController.text = savedPassword;
      });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Previous login info reloaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void buttonClicked() {
    setState(() {
      if (_passwordController.text == "ASDF") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });

    _showLoginDialog();
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Login Info?'),
          content: const Text('Would you like to save your username and password?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _prefs.clear();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _prefs.setString('login_name', _loginController.text);
                await _prefs.setString('password', _passwordController.text);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                    labelText: "Login name"
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "password"
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: buttonClicked,
                child: const Text("Login"),
              ),
            ),

            Semantics(
              label: 'Image for responding login',
              child: Image.asset(
                imageSource,
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}