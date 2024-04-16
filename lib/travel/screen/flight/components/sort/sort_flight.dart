import 'package:flutter/material.dart';

import '../../../../widget/widget.dart';
class SortFlightScreen extends StatefulWidget {
  const SortFlightScreen({super.key});

  static const String routeName = '/sort_flight';

  @override
  State<SortFlightScreen> createState() => _SortFlightScreenState();
}

class _SortFlightScreenState extends State<SortFlightScreen> {
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
                  title: 'Earliest Departure',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(0);
                    sortName = 'earliest_departure';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 1,
                  title: 'Latest Departure',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(1);
                    sortName = 'latest_departure';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 2,
                  title: 'Earliest Arrive',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(2);
                    sortName = 'earliest_arrive';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 3,
                  title: 'Latest Arrive',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(3);
                    sortName = 'latest_arrive';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 4,
                  title: 'Shortest Duration',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(4);
                    sortName = 'shortest_duration';
                  },
                ),
                CheckItem(
                  checkbox: _selectedItemIndex == 5,
                  title: 'Lowest Price',
                  radius: 12,
                  onToggle: () {
                    _handleToggle(5);
                    sortName = 'lowest_price';
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