import 'package:flutter/material.dart';

import '../../../../../config/app_path.dart';
import '../../../../widget/widget.dart';


class FacilitiesFlightScreen extends StatefulWidget {
  const FacilitiesFlightScreen({super.key});

  static const String routeName = '/facilities_flight';

  @override
  State<FacilitiesFlightScreen> createState() => _FacilitiesFlightScreenState();
}

class _FacilitiesFlightScreenState extends State<FacilitiesFlightScreen> {
  List<String> selectedFacilities = [];
  bool _selectAll =
  false; // Add a new state to control "Select All" functionality

  List<bool> _checkboxList = List.generate(8,
          (index) => false); // Maintain a list of checkboxes for individual items
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        titlePage: 'Facilities',
        subTitlePage: '',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _selectAll = !_selectAll;
                          _checkboxList = List.generate(8, (index) => _selectAll);
                          if (_selectAll) {
                            selectedFacilities = [
                              'Wifi',
                              'Baggage',
                              'Power / USB Port',
                              'In-Flight Meal',
                            ];
                          } else {
                            selectedFacilities = [];
                          }
                        });
                      },
                      child: Text('Select All',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: const Color(0xFF6155CC)))),
                  const SizedBox(
                    height: 20,
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[0],
                    title: 'Wifi',
                    radius: 4,
                    img: AppPath.iconWifi2,
                    onToggle: () {
                      setState(() {
                        _checkboxList[0] = !_checkboxList[0];
                        if (_checkboxList[0]) {
                          selectedFacilities.add('Wifi');
                        } else {
                          selectedFacilities.remove('Wifi');
                        }
                      });
                    },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[1],
                    title: 'Baggage',
                    radius: 4,
                    img: AppPath.iconBaggage,
                    onToggle: () {
                      setState(() {
                        _checkboxList[1] = !_checkboxList[1];
                        if (_checkboxList[1]) {
                          selectedFacilities.add('Baggage');
                        } else {
                          selectedFacilities.remove('Baggage');
                        }
                      });
                    },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[2],
                    title: 'Power / USB Port',
                    radius: 4,
                    img: AppPath.iconPower, onToggle: () {
                    setState(() {
                      _checkboxList[2] = !_checkboxList[2];
                      if (_checkboxList[2]) {
                        selectedFacilities.add('Power / USB Port');
                      } else {
                        selectedFacilities.remove('Power / USB Port');
                      }
                    });
                  },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[3],
                    title: 'In-Flight Meal',
                    radius: 4,
                    img: AppPath.iconFork, onToggle: () {
                    setState(() {
                      _checkboxList[3] = !_checkboxList[3];
                      if (_checkboxList[3]) {
                        selectedFacilities.add('In-Flight Meal');
                      } else {
                        selectedFacilities.remove('In-Flight Meal');
                      }
                    });
                  },
                  ),
                ],
              ),
              CustomButton(title: 'Done', button: () {
                Navigator.pop(context, selectedFacilities);
              })
            ],
          ),
        ),
      ),
    );
  }
}