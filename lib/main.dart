import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 - ListView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const Week6Lab(),
    );
  }
}

class Week6Lab extends StatelessWidget {
  const Week6Lab({super.key});


  final List<String> monthNames = const [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  // show analog function
  void _showMonthDialog(BuildContext context, String month) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Month Selected'),
          content: Text('You clicked on $month.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
        title: const Text('Months of the Year'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        itemCount: monthNames.length,
        itemBuilder: (context, index) {
          // create each row in below month list
          return ListTile(
            title: Text(monthNames[index], style: const TextStyle(fontSize: 18)),
            onTap: () {
              _showMonthDialog(context, monthNames[index]);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1, color: Colors.grey);
        },
      ),
    );
  }
}