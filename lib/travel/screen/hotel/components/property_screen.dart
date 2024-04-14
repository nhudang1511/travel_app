import 'package:flutter/material.dart';

import '../../../widget/widget.dart';
import 'check_item.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  static const String routeName = '/property';

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  int _selectedItemIndex = -1;
  String sortName = 'All';
  void _handleToggle(int index) {
    setState(() {
      if (_selectedItemIndex == index) {
        // If the same item is tapped again, deselect it
        _selectedItemIndex = -1;
      } else {
        _selectedItemIndex = index;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Property Type',
        subTitlePage: '',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CheckItem(
                  checkbox: _selectedItemIndex == 0,
                  title: 'Hotels',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(0);
                    sortName = 'Hotels';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 1,
                  title: 'Resorts',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(1);
                    sortName = 'Resorts';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 2,
                  title: 'Villas',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(2);
                    sortName = 'Villas';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 3,
                  title: 'Guest Houses',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(3);
                    sortName = 'Guest Houses';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 4,
                  title: 'Homestays',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(4);
                    sortName = 'Homestays';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 5,
                  title: 'Apartments',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(5);
                    sortName = 'Apartments';
                  },
                ),
              ],
            ),
            CustomButton(title: 'Apply', button: () {
              Navigator.pop(context, sortName);
            })
          ],
        ),
      ),
    );
  }
}
