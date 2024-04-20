import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/screen/screen.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../config/app_path.dart';
import '../../../../config/image_helper.dart';
import '../../../bloc/flight/flight_bloc.dart';
import '../../../repository/flight_repository.dart';
import '../../booking_hotel/components/item_booking.dart';

class OneWayScreen extends StatefulWidget {
  const OneWayScreen({super.key});

  @override
  State<OneWayScreen> createState() => _OneWayScreenState();
}

class _OneWayScreenState extends State<OneWayScreen> {
  String? from;
  String? to;
  String? date;
  DateTime? selectedTime;
  int? passengers;
  final countryPicker = FlCountryCodePicker(
      title: Container(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: const Text(
            "Select your country",
          )),
      showDialCode: false,
      searchBarDecoration: const InputDecoration(
        hintText: 'Country',
      ));
  CountryCode? countryCode = CountryCode.fromName('United States');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              ItemOptionsBookingWidget(
                title: 'From',
                value: from ?? 'All',
                icon: AppPath.iconFlightFrom,
                onTap: () async {
                  final code = await countryPicker.showPicker(
                    context: context,
                    scrollToDeviceLocale: true,
                  );
                  if (code != null) {
                    setState(() {
                      countryCode = code;
                      from = code.name;
                      if (from == "United States") {
                        from = "USA";
                      }
                    });
                  }
                },
              ),
              ItemOptionsBookingWidget(
                title: 'To',
                value: to ?? "All",
                icon: AppPath.iconFlightTo,
                onTap: () async {
                  final code = await countryPicker.showPicker(
                    context: context,
                    scrollToDeviceLocale: true,
                  );
                  if (code != null) {
                    setState(() {
                      countryCode = code;
                      to = code.name;
                    });
                  }
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Departure',
                value: date ?? 'Select date',
                icon: AppPath.iconDeparture,
                onTap: () async {
                  final result = await Navigator.of(context).pushNamed(
                      SelectDateScreen.routeName,
                      arguments: DateRangePickerSelectionMode.single);
                  if (result != null) {
                    DateTime? startDate = result as DateTime?;
                    final dateFormatter = DateFormat('dd MMM yyyy');
                    setState(() {
                      date = dateFormatter.format(startDate!);
                      selectedTime = startDate;
                    });
                  }
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Passengers',
                value: passengers != null
                    ? '$passengers passenger'
                    : 'Select Passengers',
                icon: AppPath.iconPassengers,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: InputQty(
                            maxVal: 42,
                            initVal: 1,
                            minVal: 1,
                            steps: 10,
                            decoration: const QtyDecorationProps(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(30),
                            ),
                            onQtyChanged: (val) {
                              setState(() {
                                passengers = val.toInt();
                              });
                            },
                          ),
                        );
                      });
                },
              ),
              CustomButton(
                  title: 'Search',
                  button: () {
                    if (from != null && to != null) {
                      Navigator.pushNamed(context, ResultFlightScreen.routeName,
                          arguments: {
                            'from_place': from,
                            'to_place': to,
                            'departure': selectedTime,
                            'passengers': passengers,
                          });
                    } else {
                      Navigator.pushNamed(context, ResultFlightScreen.routeName,
                          arguments: {
                            'from_place': "All",
                            'to_place': "All",
                            'departure': selectedTime,
                            'passengers': passengers,
                          });
                    }
                  })
            ],
          ),
          Positioned(
            top: 60,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  String? temp = from;
                  from = to;
                  to = temp;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0DDF5),
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder()),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ImageHelper.loadFromAsset(AppPath.iconArrow),
              ),
            ),
          )
        ],
      ),
    );
  }
}
