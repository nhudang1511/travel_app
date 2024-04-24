import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/promo/promo_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/promo_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/promo_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/main_screen.dart';
import 'package:flutter_nhu_nguyen/travel/widget/custom_button.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class promoCodeState extends StatefulWidget {
  const promoCodeState({super.key});

  static const String routeName = '/promo_code';

  @override
  State<promoCodeState> createState() => _promoCodeStateState();
}

class _promoCodeStateState extends State<promoCodeState> {
  late Promo promo;
  late PromoBloc promoBloc;
  String id = '123';
  @override
  void initState() {
    super.initState();
    promoBloc = PromoBloc(PromoRepository())..add(LoadPromo(id));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => promoBloc),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8F67E8), Color(0xff6357CC)],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: CouponCard(
            curveAxis: Axis.horizontal,
            backgroundColor: Colors.white,
            height: MediaQuery.of(context).size.height - 20,
            firstChild: Center(
              child: Text(
                'Congratulations!\n Promo Code',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            secondChild: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                  border: DashedBorder(
                dashLength: 15,
                top: BorderSide(color: Color(0xFFE5E5E5)),
              )),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Details Code',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.amber,
                            fontSize: 30,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<PromoBloc, PromoState>(
                      builder: (context, state) {
                        if (state is PromoLoaded) {
                          return Column(
                            children: [
                              Text(
                                'Code',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: Colors.amber,
                                      fontSize: 24,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                state.promo?.code ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Price',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: Colors.amber,
                                      fontSize: 24,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                (state.promo?.price).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 100),
                              CustomButton(
                                  title: 'Home',
                                  button: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        MainScreen.routeName, (route) => false);
                                  })
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
