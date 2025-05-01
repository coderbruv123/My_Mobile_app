import 'dart:convert';
import 'package:bca_student_app/app/PokemoninfoPage.dart';
import 'package:bca_student_app/app/pages/category_poke.dart';
import 'package:bca_student_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/pokemon_service.dart';
import '../widgets/pokemon_grid.dart';
import 'profile_page.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 1;
  List<Map<String, dynamic>> _pokemonList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPokemonData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchPokemonData() async {
  try {
    final fetchedPokemon = await PokemonService.fetchPokemonData();
    print('Fetched Pokémon: $fetchedPokemon'); // Debug the fetched data
    setState(() {
      _pokemonList = fetchedPokemon;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
  }
}

  void _onPokemonTap(Map<String, dynamic> pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemoninfoPage(pokemon: pokemon), 
      ),
    );
  }


  void _onItemTapped(int index) {
    print('Selected Index: $index'); 
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text("Menu Bar")),
            ListTile(title: const Text('Home'), onTap: () {}),
            ListTile(title: const Text('Pokemon Type'), onTap: () {}),
            ListTile(title: const Text('Profile'), onTap: () {}),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: ListTile(
          title: const Text(
            "Pokedex",
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.904),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: const Text(
            "v1.0.0",
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: CircleAvatar(
            radius: 15,
          ),
        ),
        bottom: _selectedIndex == 1
            ? TabBar(
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(icon: Icon(Icons.home, color: Colors.black)),
                  Tab(icon: Icon(Icons.feed, color: Colors.black)),
                ],
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () async {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black, size: 25),
            onPressed: () async {},
          ),
        ],
      ),
      body:
      _selectedIndex==0 ?
      CategoryPokePage():
       _selectedIndex == 2
          ? const ProfilePage()
          : _selectedIndex == 1
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PokemonGrid(
                            pokemonList: _pokemonList,
                            onPokemonTap: _onPokemonTap,
                          ),
                    const Text("Feed Page"),
                  ],
                )
              : const Center(child: Text("Other Pages")),
      bottomNavigationBar: BottomNavigationBarExample(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}




