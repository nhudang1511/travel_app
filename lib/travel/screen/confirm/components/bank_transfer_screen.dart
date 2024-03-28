import 'package:flutter/material.dart';

import '../../../../config/app_path.dart';
import '../../../widget/widget.dart';

class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen({super.key});

  static const String routeName = '/bank_transfer';

  @override
  Widget build(BuildContext context) {
    return CustomAppBarItem(title: '',
    isIcon: false,
    showModalBottomSheet: () {  },
    child: SingleChildScrollView(
      child: Column(
        children: [
          Text('Bank: Agribank'),
          Text('Account owner: NGUYEN THI QUYNH NHU'),
          Text('Account number: 7706205089173'),
          Image.asset(AppPath.qr)
        ],
      ),
    ),);
  }
}
