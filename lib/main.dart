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
      title: 'Lab 9',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Master-Detail Layout'),
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

  ShoppingItem? selectedItem = null;

  @override
  void initState() {
    super.initState();
    // Create database
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((database) {
      dao = database.shoppingItemDao;
      dao.findAllItems().then((list) {
        setState(() {
          _shoppingList = list;
        });
      });
    });
  }

  void _addItem() {
    if (_itemController.text.isNotEmpty && _qtyController.text.isNotEmpty) {
      final newItem = ShoppingItem(
          ShoppingItem.ID,
          _itemController.text,
          _qtyController.text
      );

      dao.insertItem(newItem).then((_) {
        dao.findAllItems().then((list) {
          setState(() {
            _shoppingList = list;
          });
        });
      });

      _itemController.clear();
      _qtyController.clear();
    }
  }

  Widget ListPage() {
    if (_shoppingList.isEmpty) {
      return const Center(
        child: Text("There are no items in the list", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: _shoppingList.length,
      itemBuilder: (context, index) {
        final item = _shoppingList[index];
        return InkWell(
          onTap: () {
            setState(() {
              selectedItem = item;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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

  // show item details
  Widget DetailsPage() {
    if (selectedItem == null) {
      return const Center(child: Text("Select an item from the list"));
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Item Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            // Hiển thị ID, Tên, Số lượng
            Text('ID: ${selectedItem!.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Name: ${selectedItem!.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Quantity: ${selectedItem!.quantity}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // delete item
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    dao.deleteItem(selectedItem!).then((_) {
                      dao.findAllItems().then((list) {
                        setState(() {
                          _shoppingList = list;
                          selectedItem = null;
                        });
                      });
                    });
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.white)),
                ),
                // close button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItem = null;
                    });
                  },
                  child: const Text("Close"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Layout function

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // Landscape mode
    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ListPage(),
          ),
          Expanded(
            flex: 1,
            child: DetailsPage(),
          ),
        ],
      );
    }
    // turn on portrait mode
    else {
      if (selectedItem == null) {
        return ListPage(); // show list if didn't choose
      } else {
        return DetailsPage(); // show Details Page
      }
    }
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
                    decoration: const InputDecoration(hintText: "Item", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(hintText: "Quantity", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: reactiveLayout(), // call scaling method
          ),
        ],
      ),
    );
  }
}