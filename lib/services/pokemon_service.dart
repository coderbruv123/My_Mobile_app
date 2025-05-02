import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static Future<List<Map<String, dynamic>>> fetchPokemonData() async {
    const url = 'https://pokeapi.co/api/v2/pokemon?limit=50';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        final List<Map<String, dynamic>> fetchedPokemon = [];
        for (var pokemon in results) {
          final pokemonDetails = await http.get(Uri.parse(pokemon['url']));
          if (pokemonDetails.statusCode == 200) {
            final detailsData = json.decode(pokemonDetails.body);

         

            final types = detailsData['types']
                .map((typeInfo) => typeInfo['type']['name'])
                .toList();

            fetchedPokemon.add({
              'name': pokemon['name'],
              'image': detailsData['sprites']['front_default'],
              'types': types,
              'speciesUrl': detailsData['species']['url'], 
            });
          }
        }
        return fetchedPokemon;
      } else {
        throw Exception('Failed to fetch Pokémon data');
      }
    } catch (e) {
      return [];
    }
  }

}