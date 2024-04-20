import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../widget/widget.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({super.key, required this.selectionMode});
  static const String routeName = '/date';

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();

  final DateRangePickerSelectionMode selectionMode;
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime? rangeStartDate;
  DateTime? rangeEndDate;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(titlePage: 'Select date', subTitlePage: ''),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: widget.selectionMode,
              monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              selectionColor: const Color(0xffFE9C5E),
              startRangeSelectionColor:const Color(0xffFE9C5E),
              endRangeSelectionColor:const Color(0xffFE9C5E),
              rangeSelectionColor:const Color(0xffFE9C5E).withOpacity(0.25),
              todayHighlightColor:const Color(0xffFE9C5E),
              selectionShape: DateRangePickerSelectionShape.rectangle,
              toggleDaySelection: true,
              minDate: DateTime.now(),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (widget.selectionMode == DateRangePickerSelectionMode.single) {
                  selectedDate = args.value is DateTime ? args.value : null;
                } else if (widget.selectionMode == DateRangePickerSelectionMode.range) {
                  if (args.value is PickerDateRange) {
                    rangeStartDate = args.value.startDate;
                    rangeEndDate = args.value.endDate;
                  }
                }
              },
            ),
            CustomButton(title: 'Select', button: () {
              if (widget.selectionMode == DateRangePickerSelectionMode.single) {
                Navigator.of(context).pop(selectedDate);
              } else if (widget.selectionMode == DateRangePickerSelectionMode.range) {
                Navigator.of(context).pop([rangeStartDate, rangeEndDate]);
              }
            }),
            CustomButton2(
              title: 'Cancel',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
