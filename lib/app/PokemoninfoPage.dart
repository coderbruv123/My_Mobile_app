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
  List<String> _evolutionChain = [];
  bool _isLoadingEvolution = true;

  @override
  void initState() {
    super.initState();
    _fetchEvolutionChain();
  }

  Future<void> _fetchEvolutionChain() async {
    try {
      // Fetch species data to get the evolution chain URL
      final speciesResponse = await http.get(Uri.parse(widget.pokemon['speciesUrl']));
      if (speciesResponse.statusCode == 200) {
        final speciesData = json.decode(speciesResponse.body);
        final evolutionChainUrl = speciesData['evolution_chain']['url'];

        // Fetch evolution chain data
        final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
        if (evolutionResponse.statusCode == 200) {
          final evolutionData = json.decode(evolutionResponse.body);
          final chain = evolutionData['chain'];

          // Parse the evolution chain
          List<String> evolutionChain = [];
          var current = chain;
          while (current != null) {
            evolutionChain.add(current['species']['name']);
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
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    evolution.toUpperCase(),
                                    style: const TextStyle(fontSize: 18),
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
