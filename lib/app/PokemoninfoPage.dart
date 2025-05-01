import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/type_colors.dart';

class PokemoninfoPage extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const PokemoninfoPage({super.key, required this.pokemon});

  @override
  PokemoninfoPageState createState() => PokemoninfoPageState();
}

class PokemoninfoPageState extends State<PokemoninfoPage> {
  List<Map<String, String>> _evolutionChain = [];
  bool _isLoadingEvolution = true;

  @override
  void initState() {
    super.initState();
    _fetchEvolutionChain();
  }

  Future<void> _fetchEvolutionChain() async {
    try {
      final speciesUrl = widget.pokemon['speciesUrl'];
      final speciesResponse = await http.get(Uri.parse(speciesUrl));

      if (speciesResponse.statusCode == 200) {
        final speciesData = json.decode(speciesResponse.body);

        final evolutionChainUrl = speciesData['evolution_chain']?['url'] ?? '';
        if (evolutionChainUrl.isEmpty) {
          setState(() {
            _isLoadingEvolution = false;
          });
          return;
        }

        print('Fetching evolution chain data from: $evolutionChainUrl');
        final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));

        if (evolutionResponse.statusCode == 200) {
          final evolutionData = json.decode(evolutionResponse.body);
          final chain = evolutionData['chain'];

          List<Map<String, String>> evolutionChain = [];
          var current = chain;
          while (current != null) {
            final speciesName = current['species']['name'];
            print('Fetching Pokémon details for: $speciesName');

            final pokemonResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$speciesName'));
            String? imageUrl;
            if (pokemonResponse.statusCode == 200) {
              final pokemonData = json.decode(pokemonResponse.body);
              imageUrl = pokemonData['sprites']?['front_default'];
            }

            evolutionChain.add({
              'name': speciesName,
              'image': imageUrl ?? 'https://via.placeholder.com/150', // Fallback to placeholder if image is null
            });

            current = current['evolves_to'].isNotEmpty ? current['evolves_to'][0] : null;
          }

          setState(() {
            _evolutionChain = evolutionChain;
            _isLoadingEvolution = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching evolution chain: $e');
      setState(() {
        _isLoadingEvolution = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryType = widget.pokemon['types'][0];
    final backgroundpokeColor = typeColors[primaryType] ?? Colors.white;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: AppBar(
            backgroundColor: backgroundpokeColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.pokemon['image'] ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 30);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              widget.pokemon['name'].toUpperCase() ?? 'Unknown',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: widget.pokemon['types']
                  .map<Widget>((type) => Chip(
                        label: Text(
                          type.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: typeColors[type] ?? Colors.grey,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            const Text(
              'Evolution Chain',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _isLoadingEvolution
                ? const CircularProgressIndicator()
                : _evolutionChain.isEmpty
                    ? const Text('No evolution data available.')
                    : Column(
                        children: _evolutionChain
                            .map((evolution) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        evolution['image']!,
                                        height: 50,
                                        width: 50,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.error, size: 50);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        evolution['name']!.toUpperCase(),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
