import 'package:flutter/material.dart';

import '../../../widget/widget.dart';
import 'check_item.dart';

class SortScreen extends StatefulWidget {
  const SortScreen({super.key});

  static const String routeName = '/sort';

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
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
        titlePage: 'Sort by',
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
                  title: 'Highest popularity',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(0);
                    sortName = 'total_review';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 1,
                  title: 'Highest Price',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(1);
                    sortName = 'price';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 2,
                  title: 'Highest Rating',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(2);
                    sortName = 'rating';
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
