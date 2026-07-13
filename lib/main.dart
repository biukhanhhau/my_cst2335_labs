import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7',
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
  List<ShoppingItem> _shoppingList = [];

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  late ShoppingItemDao dao;

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((database) {
      dao = database.shoppingItemDao;
      dao.findAllItems().then((list) {
        setState(() {
          _shoppingList = list;
        });
      });
    });
  }

  // add function
  void _addItem() {
    if (_itemController.text.isNotEmpty && _qtyController.text.isNotEmpty) {

      //create new Object
      final newItem = ShoppingItem(
          ShoppingItem.ID,
          _itemController.text,
          _qtyController.text
      );

      // add to DB and setState again
      dao.insertItem(newItem).then((_) {
        dao.findAllItems().then((list) {
          setState(() {
            _shoppingList = list;
          });
        });
      });

      // delete after adding
      _itemController.clear();
      _qtyController.clear();
    }
  }

  void _showDeleteDialog(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item?'),
          content: Text('Are you sure you want to delete ${item.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                dao.deleteItem(item).then((_) {
                  dao.findAllItems().then((list) {
                    setState(() {
                      _shoppingList = list;
                    });
                  });
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
    if (_shoppingList.isEmpty) {
      return const Center(
        child: Text(
          "There are no items in the list",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _shoppingList.length,
      itemBuilder: (context, index) {
        final item = _shoppingList[index];

        return InkWell(
          onLongPress: () {
            _showDeleteDialog(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${index + 1}: ${item.name}', style: const TextStyle(fontSize: 16)),
                Text('quantity: ${item.quantity}', style: const TextStyle(fontSize: 16)),
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