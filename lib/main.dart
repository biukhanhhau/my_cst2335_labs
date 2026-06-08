import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Dòng này giúp tắt chữ DEBUG màu đỏ ở góc
      title: 'Lab 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Đã sửa lỗi .fromSeed
      ),
      home: const MyHomePage(title: 'Favorite Recipes'), // Đổi tiêu đề cho giống bài lab
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

  Widget buildRecipeItem(String imagePath, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(        // clip rounded rectangle
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,       // swell up the entire width
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.favorite, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget createLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(child: buildRecipeItem("images/stir_fry.jpg", "Veggie Stir-fry", "Colorful, crisp")),
            Expanded(child: buildRecipeItem("images/salad.jpg", "Caesar Salad", "Crisp, creamy")),
          ],
        ),
        Row(
          children: [
            Expanded(child: buildRecipeItem("images/sushi.jpg", "Sushi Rolls", "Fresh, delicate")),
            Expanded(child: buildRecipeItem("images/brownie.jpg", "Chocolate Brownie", "Rich, fudgy")),
          ],
        ),
        Row(
          children: [
            Expanded(child: buildRecipeItem("images/salmon.jpg", "Grilled Salmon", "Juicy, smoky")),
            Expanded(child: buildRecipeItem("images/tacos.jpg", "Beef Tacos", "Spicy, crunchy")),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: SingleChildScrollView(
        child: createLayout(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ensure that it will show icon if there are no text
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
        onTap: (index) {},
      ),
    );
  }
}