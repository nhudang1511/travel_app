import 'package:flutter_bloc/flutter_bloc.dart';
class AppObserver extends BlocObserver {
  const AppObserver();
  //BlocObserver: observe all state changes in the application.

  // @override
  // void onEvent(Bloc bloc, Object? event){
  //   super.onEvent(bloc, event);
  //   // ignore: avoid_print
  //   print('${bloc.runtimeType} $event');
  // }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('${bloc.runtimeType} $change');
  }
}
