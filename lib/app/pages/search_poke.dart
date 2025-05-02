import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPoke extends StatefulWidget {
  const SearchPoke({super.key});

  @override
  State<SearchPoke> createState() => _SearchPokeState();
}

class _SearchPokeState extends State<SearchPoke> {
  String searchQuery = '';




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Pokémon'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Pokémon...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          searchQuery.isEmpty
              ? 'Search Pokémon functionality will be implemented here.'
              : 'Searching for: $searchQuery',
          style: const TextStyle(fontSize: 16),
        ),
        
      ),
    );
  }
}