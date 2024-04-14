import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import '../../../widget/widget.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  static const String routeName = '/facilities';

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
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
                              'FREE_WIFI',
                              'NON_REFUNDABLE',
                              'NON_SMOKING',
                              'CURRENCY_EXCHANGE',
                              'RESTAURANT',
                              'CAR_RENTAL',
                              '24_HOURS_FRONT_DESK',
                              'SWIMMING_POOL'
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
                    title: 'FREE_WIFI',
                    radius: 4,
                    img: AppPath.iconWifi2,
                    onToggle: () {
                      setState(() {
                        _checkboxList[0] = !_checkboxList[0];
                        if (_checkboxList[0]) {
                          selectedFacilities.add('FREE_WIFI');
                        } else {
                          selectedFacilities.remove('FREE_WIFI');
                        }
                      });
                    },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[1],
                    title: 'NON_REFUNDABLE',
                    radius: 4,
                    img: AppPath.iconNonRefund,
                    onToggle: () {
                      setState(() {
                        _checkboxList[1] = !_checkboxList[1];
                        if (_checkboxList[1]) {
                          selectedFacilities.add('NON_REFUNDABLE');
                        } else {
                          selectedFacilities.remove('NON_REFUNDABLE');
                        }
                      });
                    },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[2],
                    title: 'NON_SMOKING',
                    radius: 4,
                    img: AppPath.iconNonSmoking, onToggle: () {
                    setState(() {
                      _checkboxList[2] = !_checkboxList[2];
                      if (_checkboxList[2]) {
                        selectedFacilities.add('NON_SMOKING');
                      } else {
                        selectedFacilities.remove('NON_SMOKING');
                      }
                    });
                  },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[3],
                    title: 'SWIMMING_POOL',
                    radius: 4,
                    img: AppPath.iconPool, onToggle: () {
                    setState(() {
                      _checkboxList[3] = !_checkboxList[3];
                      if (_checkboxList[3]) {
                        selectedFacilities.add('SWIMMING_POOL');
                      } else {
                        selectedFacilities.remove('SWIMMING_POOL');
                      }
                    });
                  },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[4],
                    title: 'CURRENCY_EXCHANGE',
                    radius: 4,
                    img: AppPath.iconExchange, onToggle: () {
                    setState(() {
                      _checkboxList[4] = !_checkboxList[4];
                      if (_checkboxList[4]) {
                        selectedFacilities.add('CURRENCY_EXCHANGE');
                      } else {
                        selectedFacilities.remove('CURRENCY_EXCHANGE');
                      }
                    });
                  },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[5],
                    title: 'RESTAURANT',
                    radius: 4,
                    img: AppPath.iconFork, onToggle: () {
                    setState(() {
                      _checkboxList[5] = !_checkboxList[5];
                      if (_checkboxList[5]) {
                        selectedFacilities.add('RESTAURANT');
                      } else {
                        selectedFacilities.remove('RESTAURANT');
                      }
                    });
                  },
                  ),
                  FacilitiesItem(
                    checkbox: _checkboxList[7],
                    title: '24_HOURS_FRONT_DESK',
                    radius: 4,
                    img: AppPath.iconReception, onToggle: () {
                    setState(() {
                      _checkboxList[7] = !_checkboxList[7];
                      if (_checkboxList[7]) {
                        selectedFacilities.add('24_HOURS_FRONT_DESK');
                      } else {
                        selectedFacilities.remove('24_HOURS_FRONT_DESK');
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

class FacilitiesItem extends StatefulWidget {
  const FacilitiesItem({
    super.key,
    required this.checkbox,
    required this.title,
    required this.radius,
    required this.img,
    required this.onToggle,
  });

  final bool checkbox;
  final String title;
  final double radius;
  final String img;
  final VoidCallback onToggle;

  @override
  State<FacilitiesItem> createState() => _FacilitiesItemState();
}

class _FacilitiesItemState extends State<FacilitiesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(widget.img),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: const Color(0xFF313131)),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: const Color(0xFFE0DDF5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.radius)),
              ),
              child: widget.checkbox
                  ? const Icon(
                      Icons.check,
                      color: Color(0xFF6155CC),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
