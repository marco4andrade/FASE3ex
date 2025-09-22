import 'package:flutter/material.dart';

import 'products_page.dart';
import 'users_page.dart';
import 'carts_page.dart';

/// Pantalla principal con navegación por pestañas
///
/// Implementa el patrón de navegación por pestañas usando NavigationBar
/// Respeta el principio de Responsabilidad Única (SRP)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const ProductsPage(),
    const UsersPage(),
    const CartsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;
    final isMediumScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            isLargeScreen
                ? 'Clean Architecture - Fake Store API'
                : isMediumScreen
                ? 'Clean Architecture - Fake Store'
                : 'Fake Store API',
            style: TextStyle(
              fontSize: isLargeScreen
                  ? 20
                  : isMediumScreen
                  ? 18
                  : 16,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: isLargeScreen
          ? _buildDesktopLayout()
          : _pages.elementAt(_selectedIndex),
      bottomNavigationBar: isLargeScreen ? null : _buildBottomNavigation(),
      drawer: isMediumScreen && !isLargeScreen ? _buildDrawer() : null,
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar navigation para pantallas grandes
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          labelType: NavigationRailLabelType.all,
          backgroundColor: Theme.of(context).colorScheme.surface,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: Text('Productos'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people_outlined),
              selectedIcon: Icon(Icons.people),
              label: Text('Usuarios'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: Text('Carritos'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        // Contenido principal
        Expanded(child: _pages.elementAt(_selectedIndex)),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: 'Productos',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: 'Usuarios',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Carritos',
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Text(
              'Fake Store API',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Productos'),
            selected: _selectedIndex == 0,
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Usuarios'),
            selected: _selectedIndex == 1,
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carritos'),
            selected: _selectedIndex == 2,
            onTap: () {
              _onItemTapped(2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
