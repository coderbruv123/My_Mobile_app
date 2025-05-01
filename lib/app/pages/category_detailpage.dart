import 'package:bca_student_app/app/PokemoninfoPage.dart';
import 'package:bca_student_app/utils/type_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryUrl;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryUrl,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Map<String, dynamic>> _pokemonList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoryPokemon();
  }

  Future<void> _fetchCategoryPokemon() async {
    try {
      final response = await http.get(Uri.parse(widget.categoryUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List pokemons = data['pokemon'] ?? [];
     
        if (!mounted) return;

        setState(() {
          _pokemonList = pokemons
              .map((pokemon) => {
                    'name': pokemon['pokemon']['name'],
                    'url': pokemon['pokemon']['url'],
                    'image': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon['pokemon']['url'].split('/')[6]}.png',
                    'speciesUrl': 'https://pokeapi.co/api/v2/pokemon-species/${pokemon['pokemon']['url'].split('/')[6]}/', // Correct species URL
                    'types': [widget.categoryName],
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch Pokémon for category');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Pokémon'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pokemonList.isEmpty
              ? const Center(child: Text('No Pokémon found for this category.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = _pokemonList[index];
                    print('Building Grid Item for: $pokemon');

                    final primaryType = (pokemon['types'] != null && pokemon['types'].isNotEmpty)
                        ? pokemon['types'][0]
                        : 'unknown';
                    final backgroundColor = typeColors[primaryType] ?? Colors.grey;

                    return GestureDetector(
                      onTap: () {
                        print('Tapped on Pokémon: ${pokemon['name']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
        builder: (context) => PokemoninfoPage(pokemon: pokemon), 
      
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: backgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              pokemon['image'] ?? 'https://via.placeholder.com/150',
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50);
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pokemon['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}