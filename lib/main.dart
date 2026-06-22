import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class DataRepository {
  static String loginName = '';
  static String password = '';
  static String firstName = '';
  static String lastName = '';
  static String phoneNumber = '';
  static String email = '';

  static final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    loginName = await prefs.getString('login_name');
    password = await prefs.getString('password');
    firstName = await prefs.getString('first_name');
    lastName = await prefs.getString('last_name');
    phoneNumber = await prefs.getString('phone_number');
    email = await prefs.getString('email');
  }

  static Future<void> saveData() async {
    await prefs.setString('login_name', loginName);
    await prefs.setString('password', password);
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('phone_number', phoneNumber);
    await prefs.setString('email', email);
  }
}

// Declare app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 5',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      // declare 2 route
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Login Page'),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

// Login - used lab 4
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

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();

    DataRepository.loadData().then((_) {
      if (DataRepository.loginName.isNotEmpty) {
        setState(() {
          _loginController.text = DataRepository.loginName;
          _passwordController.text = DataRepository.password;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loaded from Repository!')),
        );
      }
    });
  }

  void buttonClicked() {
    setState(() {
      if (_passwordController.text == "ASDF") {
        imageSource = "images/light-bulb.png";
      } else {
        imageSource = "images/stop-sign.png";
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Login Info?'),
          content: const Text('Would you like to save your username and password?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                DataRepository.prefs.clear(); // press no = clear
                checkPasswordAndGo();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                DataRepository.loginName = _loginController.text;
                DataRepository.password = _passwordController.text;
                DataRepository.saveData();
                checkPasswordAndGo();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void checkPasswordAndGo() {
    if (_passwordController.text == "ASDF") {
      DataRepository.loginName = _loginController.text;
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _loginController, decoration: const InputDecoration(labelText: "Login name"))),
            Padding(padding: const EdgeInsets.all(8.0), child: TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password"))),
            Padding(padding: const EdgeInsets.all(8.0), child: ElevatedButton(onPressed: buttonClicked, child: const Text("Login"))),
            Image.asset(imageSource, width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}

// page 2
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // fetch data from repository
    _firstNameController.text = DataRepository.firstName;
    _lastNameController.text = DataRepository.lastName;
    _phoneController.text = DataRepository.phoneNumber;
    _emailController.text = DataRepository.email;


    _firstNameController.addListener(() { DataRepository.firstName = _firstNameController.text; DataRepository.saveData(); });
    _lastNameController.addListener(() { DataRepository.lastName = _lastNameController.text; DataRepository.saveData(); });
    _phoneController.addListener(() { DataRepository.phoneNumber = _phoneController.text; DataRepository.saveData(); });
    _emailController.addListener(() { DataRepository.email = _emailController.text; DataRepository.saveData(); });

    // show snackbar
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back ${DataRepository.loginName}")),
      );
    });
  }


  void openApp(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('URL is not supported on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: "Last Name")),

            //Phone
            Row(
              children: [
                Flexible(child: TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"))),
                IconButton(icon: const Icon(Icons.phone), onPressed: () => openApp("tel:${_phoneController.text}")),
                IconButton(icon: const Icon(Icons.message), onPressed: () => openApp("sms:${_phoneController.text}")),
              ],
            ),

            //Email
            Row(
              children: [
                Flexible(child: TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email address"))),
                IconButton(icon: const Icon(Icons.email), onPressed: () => openApp("mailto:${_emailController.text}")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}