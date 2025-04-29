
import 'package:bca_student_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static final List<Widget> _widgetOptions = <Widget>[
      Text("Home Page"),
      Text("Home Page"),
      Text("Home Page"),

  ];

  void _onItemTapped(int index) {
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
            ListTile(title: const Text('Calender'), onTap: () {}),
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
        bottom:
            _selectedIndex == 1
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
          _selectedIndex == 1
              ? TabBarView(
                controller: _tabController,
                children: const [
                  Text("Home Page"),
                  // Center(child: Text("Home Page")),
                  Text("Feed Page"),
                ],
              )
              : _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBarExample(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
