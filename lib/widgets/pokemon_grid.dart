import 'package:flutter/material.dart';
import '../utils/type_colors.dart';

class PokemonGrid extends StatelessWidget {
  final List<Map<String, dynamic>> pokemonList;
  final Function(Map<String, dynamic>) onPokemonTap;

  const PokemonGrid({
    Key? key,
    required this.pokemonList,
    required this.onPokemonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        final primaryType = pokemon['types'][0]; 
        final backgroundColor = typeColors[primaryType] ?? Colors.white;

        return GestureDetector(
          onTap: () => onPokemonTap(pokemon),
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
                  pokemon['name']!,
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
    );
  }
}