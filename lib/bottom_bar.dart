import 'package:assignment_app/pages/page_a.dart';
import 'package:assignment_app/pages/page_b.dart';
import 'package:assignment_app/pages/page_c.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const PageA(),
    const PageB(),
    const PageC(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0XFF526480),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_data_area_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_data_area_filled),
              label: "A"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_phone_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_phone_filled),
              label: "B"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_status_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_status_filled),
              label: "C"),
        ],
      ),
    );
  }
}
