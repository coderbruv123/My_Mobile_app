import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryPokePage extends StatefulWidget {
  const CategoryPokePage({super.key});

  @override
  State<CategoryPokePage> createState() => _CategoryPokePageState();
}

class _CategoryPokePageState extends State<CategoryPokePage> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    const url = 'https://pokeapi.co/api/v2/type'; // Endpoint for Pokémon types
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        setState(() {
          _categories = results
              .map((category) => {
                    'name': category['name'],
                    'url': category['url'],
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching categories: $e');
    }
  }

  void _onCategoryTap(String name, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(categoryName: name, categoryUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Categories'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  title: Text(
                    category['name'].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _onCategoryTap(category['name'], category['url']),
                );
              },
            ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  final String categoryUrl;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Pokémon'),
      ),
      body: Center(
        child: Text(
          'Details for $categoryName Pokémon will go here.',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}