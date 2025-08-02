import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? floatingActionButton;

  const BottomNavWrapper({
    Key? key, 
    required this.child, 
    required this.title,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building BottomNavWrapper with title: $title');
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        titleSpacing: 8,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/dashboard');
                  }
                },
              )
            : null,
        actions: [
          if (!canPop) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () => context.go('/user-account'),
                  child: Text(
                    'John Doe', // Ideally personalize
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/user-account'),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
                ),
              ),
            ),
          ],
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/inventory');
        break;
      case 2:
        context.go('/schedules');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.contains('/dashboard')) {
      return 0;
    } else if (location.contains('/inventory')) {
      return 1;
    } else if (location.contains('/schedules')) {
      return 2;
    } else if (location.contains('/settings')) {
      return 3;
    }
    return 0;
  }
}

