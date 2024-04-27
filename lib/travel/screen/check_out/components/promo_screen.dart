import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/promo/promo_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/repository/promo_repository.dart';
import '../../../model/promo_model.dart';
import '../../../widget/widget.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  static const String routeName = '/promo';

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

// ... (other imports)

class _PromoScreenState extends State<PromoScreen> {
  late PromoBloc _promoBloc;
  final TextEditingController textController = TextEditingController();
  Promo? promo;

  @override
  void initState() {
    super.initState();
    _promoBloc = PromoBloc(PromoRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _promoBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          titlePage: 'Promo Code',
          subTitlePage: '',
        ),
        body: BlocListener<PromoBloc, PromoState>(
          listener: (context, state) {
            if (state is PromoLoaded) {
              promo = state.promo;
              // Dismiss the loading dialog
              Navigator.of(context, rootNavigator: true).pop();
              // Pop the screen
              Navigator.pop(context, promo);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Please enter Coupon Code',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: const Color(0xFF636363)),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: textController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CustomButton(
                  title: 'Done',
                  button: () {
                    if (textController.text.isNotEmpty) {
                      // Add the LoadPromo event
                      _promoBloc.add(LoadPromo(textController.text));
                    }

                    // Show loading state
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      barrierDismissible: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

