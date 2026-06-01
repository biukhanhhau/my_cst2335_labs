import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
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

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
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
          mainAxisAlignment: .center,
          children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                      labelText: "Login name"
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "password"
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: buttonClicked,
                  child: Text("Login"),
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
