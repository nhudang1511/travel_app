import 'package:easy_localization/easy_localization.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/config/app_path.dart';
import 'package:flutter_nhu_nguyen/travel/screen/screen.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_app_bar.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../config/shared_preferences.dart';
import 'components/item_booking.dart';

class BookingHotelScreen extends StatefulWidget {
  const BookingHotelScreen({super.key});

  static const String routeName = '/booking_hotel';

  @override
  State<BookingHotelScreen> createState() => _BookingHotelScreenState();
}

class _BookingHotelScreenState extends State<BookingHotelScreen> {
  String? selectDate;
  String? country;
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
    if(SharedService.getStartDate() != null && SharedService.getEndDate() != null){
      selectDate = '${SharedService.getStartDate()} -' '${SharedService.getEndDate()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
          titlePage: 'Hotel Booking',
          subTitlePage: 'Choose your favorite hotel and enjoy the service'),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ItemOptionsBookingWidget(
                title: 'Destination',
                value: country ?? 'Country',
                icon: AppPath.iconLocation,
                onTap: () async {
                  final code = await countryPicker.showPicker(
                    context: context,
                    scrollToDeviceLocale: true,
                  );
                  if (code != null) {
                    setState(() {
                      countryCode = code;
                      country = code.name;
                    });
                  }
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Select Date',
                value: selectDate ?? 'Select date',
                icon: AppPath.iconCalender,
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(SelectDateScreen.routeName,arguments: DateRangePickerSelectionMode.range);
                  if (result != null &&
                      result is List<DateTime?> &&
                      result.length == 2) {
                    DateTime? startDate = result[0];
                    DateTime? endDate = result[1];
                    Duration duration = endDate!.difference(startDate!);
                    int daysDifference = duration.inDays;
                    final dateFormatter = DateFormat('dd MMM yyyy');
                    setState(() {
                      selectDate =
                          '${dateFormatter.format(startDate)} - ${dateFormatter.format(endDate)}';
                      SharedService.setStartDate(
                          dateFormatter.format(startDate));
                      SharedService.setEndDate(dateFormatter.format(endDate));
                      SharedService.setDays(daysDifference);
                    });
                  }
                },
              ),
              ItemOptionsBookingWidget(
                title: 'Guest and Room',
                value: '${SharedService.getGuest() ?? 1} Guest, ${SharedService.getRoom() ?? 1} Room',
                icon: AppPath.iconBed,
                onTap: () async {
                  Map<String, dynamic> result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GuestRoomScreen()),
                  );
                  if (result.length == 2) {
                    setState(() {
                      SharedService.setRoom(result['room'] ?? 1);
                      SharedService.setGuest(result['guest'] ?? 1);
                    });
                  }
                },
              ),
              CustomButton(
                  title: 'Search',
                  button: () {
                    country ??= 'All';
                    Navigator.pushNamed(context, HotelScreen.routeName,
                        arguments: {
                          'maxGuest': SharedService.getGuest() ?? 1,
                          'maxRoom': SharedService.getRoom() ?? 1,
                          'destination': country
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
