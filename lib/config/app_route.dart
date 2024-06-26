import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_flight_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/room_model.dart';
import 'package:flutter_nhu_nguyen/travel/screen/flight/components/sort/sort_flight.dart';
import 'package:flutter_nhu_nguyen/travel/screen/reviews/reviews_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/finish_checkout/finish_checkout_flight_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/places/place_detail_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/user/user_edit_screen.dart';
import 'package:flutter_nhu_nguyen/travel/screen/write_review/promo_code.dart';
import 'package:flutter_nhu_nguyen/travel/screen/write_review/write_review_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../travel/model/filght_model.dart';
import '../travel/model/hotel_model.dart';
import '../travel/model/place_model.dart';
import '../travel/on_boarding_page.dart';
import '../travel/screen/brief_case/components/booking_flight_item.dart';
import '../travel/screen/brief_case/components/booking_item.dart';
import '../travel/screen/main_screen.dart';
import '../travel/screen/screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Kiểm tra name của RouteSettings.
      case MainScreen.routeName:
        return _route(const MainScreen());
      case UserEditScreen.routeName:
        return _route(const UserEditScreen());
      case OnBoardingPage.routeName:
        return _route(const OnBoardingPage());
      case LoginScreen.routeName:
        return _route(const LoginScreen());
      case SignUpScreen.routeName:
        return _route(const SignUpScreen());
      case ForgotScreen.routeName:
        return _route(const ForgotScreen());
      case VerifyEmailScreen.routeName:
        return _route(const VerifyEmailScreen());
      case HomeScreen.routeName:
        return _route(const HomeScreen());
      case HotelScreen.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          final int maxGuest = arguments['maxGuest'] as int;
          final int maxRoom = arguments['maxRoom'] as int;
          final String destination = arguments['destination'] as String;
          return _route(HotelScreen(
            maxGuest: maxGuest,
            maxRoom: maxRoom,
            destination: destination,
          ));
        } else {
          return _route(const MainScreen());
        }
      case DetailHotelScreen.routeName:
        final HotelModel hotelModel = (settings.arguments as HotelModel);
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (context) => DetailHotelScreen(
            hotelModel: hotelModel,
          ),
        );
      case ReviewsScreen.routeName:
        final HotelModel hotelModel = (settings.arguments as HotelModel);
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (context) => ReviewsScreen(
            hotelModel: hotelModel,
          ),
        );
      case NotificationScreen.routeName:
        return _route(const NotificationScreen());

      case WriteReviewScreen.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          final HotelModel hotelModel1 = arguments['hotelModel'] as HotelModel;
          final String booking = arguments['booking'] as String;
          return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => WriteReviewScreen(
              hotelModel: hotelModel1,
              booking: booking,
            ),
          );
        } else {
          return _route(const MainScreen());
        }
      // final HotelModel hotelModel = (settings.arguments as HotelModel);
      // final BookingModel bookingModel = (settings.arguments as BookingModel);

      //return _route(const ReviewsScreen());
      case promoCodeState.routeName:
        return _route(const promoCodeState());
      case SortScreen.routeName:
        return _route(const SortScreen());
      case FacilitiesScreen.routeName:
        return _route(const FacilitiesScreen());
      case PropertyScreen.routeName:
        return _route(const PropertyScreen());
      case SelectRoomScreen.routeName:
        final List<RoomModel> rooms = (settings.arguments as List<RoomModel>);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => SelectRoomScreen(
                  rooms: rooms,
                ));
      case CheckOutStep.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          final int step = arguments['step'] as int;
          final RoomModel room = arguments['room'] as RoomModel;
          return _route(CheckOutStep(
            step: step,
            roomModel: room,
          ));
        } else {
          return _route(const MainScreen());
        }
      case ContactScreen.routeName:
        return _route(const ContactScreen());
      case PromoScreen.routeName:
        return _route(const PromoScreen());
      case CardScreen.routeName:
        return _route(const CardScreen());
      case BookingHotelScreen.routeName:
        return _route(const BookingHotelScreen());
      case SelectDateScreen.routeName:
        final DateRangePickerSelectionMode selectionMode =
            (settings.arguments as DateRangePickerSelectionMode);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) =>
                SelectDateScreen(selectionMode: selectionMode));
      case GuestRoomScreen.routeName:
        return _route(const GuestRoomScreen());
      case AllPlacesScreen.routeName:
        final List<PlaceModel> places =
            (settings.arguments as List<PlaceModel>);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => AllPlacesScreen(
                  places: places,
                ));
      case PlaceDetailsScreen.routeName:
        final PlaceModel place = (settings.arguments as PlaceModel);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => PlaceDetailsScreen(
                  place: place,
                ));
      case BookingFlightScreen.routeName:
        return _route(const BookingFlightScreen());
      case ResultFlightScreen.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          final String? fromPlace = arguments['from_place'] as String?;
          final String? toPlace = arguments['to_place'] as String?;
          final DateTime? selectedTime = arguments['departure'] as DateTime?;
          final int? passengers = arguments['passengers'] as int?;
          return _route(ResultFlightScreen(
            fromPlace: fromPlace,
            toPlace: toPlace,
            selectedTime: selectedTime,
            passengers: passengers,
          ));
        } else {
          return _route(const MainScreen());
        }
      case CheckOutScreenFlight.routeName:
        final FlightModel flight = (settings.arguments as FlightModel);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => CheckOutScreenFlight(
                  flight: flight,
                ));
      case SelectSeatScreen.routeName:
        final FlightModel flight = (settings.arguments as FlightModel);
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (context) => SelectSeatScreen(flight: flight));
      case FinishCheckoutScreen.routeName:
        return _route(const FinishCheckoutScreen());
      case FinishCheckoutFlightScreen.routeName:
        return _route(const FinishCheckoutFlightScreen());
      case CheckOutStepFlight.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          final int step = arguments['step'] as int;
          final FlightModel flight = arguments['flight'] as FlightModel;
          return _route(CheckOutStepFlight(step: step, flightModel: flight));
        } else {
          return _route(const MainScreen());
        }
      case BookingItem.routeName:
        final BookingModel booking = (settings.arguments as BookingModel);
        return _route(BookingItem(
          booking: booking,
        ));
      case BankTransferScreen.routeName:
        return _route(const BankTransferScreen());
      case FacilitiesFlightScreen.routeName:
        return _route(const FacilitiesFlightScreen());
      case SortFlightScreen.routeName:
        return _route(const SortFlightScreen());
      case SettingScreen.routeName:
        return _route(const SettingScreen());
      case StatisticalScreen.routeName:
        return _route(const StatisticalScreen());
      case BookingFlightItem.routeName:
        final BookingFlightModel bookingFlightModel =
            (settings.arguments as BookingFlightModel);
        return _route(BookingFlightItem(
          bookingFlightModel: bookingFlightModel,
        ));
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
            ));
  }

  static Route _route(screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }
}
