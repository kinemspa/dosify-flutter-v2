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
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: canPop ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/dashboard');
            }
          },
        ) : GestureDetector(
          onTap: () => context.go('/user-account'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
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
            icon: Icon(Icons.medication),
            label: 'Medications',
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
        context.go('/medications');
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
    } else if (location.contains('/medications')) {
      return 1;
    } else if (location.contains('/schedules')) {
      return 2;
    } else if (location.contains('/settings')) {
      return 3;
    }
    return 0;
  }
}

