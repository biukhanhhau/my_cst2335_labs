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
      title: 'Lab 6',
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
  final List<String> _itemNames = [];
  final List<String> _itemQtys = [];

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  // add function
  void _addItem() {
    if (_itemController.text.isNotEmpty && _qtyController.text.isNotEmpty) {
      setState(() {
        // take data from filled form
        _itemNames.add(_itemController.text);
        _itemQtys.add(_qtyController.text);
      });
      // delete after adding
      _itemController.clear();
      _qtyController.clear();
    }
  }


  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item?'),
          content: Text('Are you sure you want to delete ${_itemNames[index]}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _itemNames.removeAt(index);
                  _itemQtys.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }


  Widget ListPage() {
    if (_itemNames.isEmpty) {
      return const Center(
        child: Text(
          "There are no items in the list",
          style: TextStyle(fontSize: 16),
        ),
      );
    }


    return ListView.builder(
      itemCount: _itemNames.length,
      itemBuilder: (context, index) {
        return InkWell(
          onLongPress: () {
            _showDeleteDialog(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${index + 1}: ${_itemNames[index]}', style: const TextStyle(fontSize: 16)),
                Text('quantity: ${_itemQtys[index]}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: "Type the item here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(
                      hintText: "Type the quantity here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Click here"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListPage(),
          ),
        ],
      ),
    );
  }
}