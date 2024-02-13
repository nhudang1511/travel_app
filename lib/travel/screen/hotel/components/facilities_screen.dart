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
                    });
                  },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[1],
                  title: 'Digital TV',
                  radius: 4,
                  img: AppPath.iconTelevision,
                  onToggle: () {
                    setState(() {
                      _checkboxList[1] = !_checkboxList[1];
                    });
                  },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[2],
                  title: 'Parking Area',
                  radius: 4,
                  img: AppPath.iconPark, onToggle: () {
                  setState(() {
                    _checkboxList[2] = !_checkboxList[2];
                  });
                },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[3],
                  title: 'Swimming Pool',
                  radius: 4,
                  img: AppPath.iconPool, onToggle: () {
                  setState(() {
                    _checkboxList[3] = !_checkboxList[3];
                  });
                },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[4],
                  title: 'Currency Exchange',
                  radius: 4,
                  img: AppPath.iconExchange, onToggle: () {
                  setState(() {
                    _checkboxList[4] = !_checkboxList[4];
                  });
                },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[5],
                  title: 'Restaurant',
                  radius: 4,
                  img: AppPath.iconFork, onToggle: () {
                  setState(() {
                    _checkboxList[5] = !_checkboxList[5];
                  });
                },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[6],
                  title: 'Car Rental',
                  radius: 4,
                  img: AppPath.iconCar, onToggle: () {
                  setState(() {
                    _checkboxList[6] = !_checkboxList[6];
                  });
                },
                ),
                FacilitiesItem(
                  checkbox: _checkboxList[7],
                  title: '24-hour Front Desk',
                  radius: 4,
                  img: AppPath.iconReception, onToggle: () {
                  setState(() {
                    _checkboxList[7] = !_checkboxList[7];
                  });
                },
                ),
              ],
            ),
            CustomButton(title: 'Done', button: () {})
          ],
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
