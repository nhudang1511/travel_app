
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static late SharedPreferences _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static bool getIsFirstTime(){
    return _pref.getBool("isFirstTime") ?? true;
  }

  static void setIsFirstTime(bool value){
    _pref.setBool("isFirstTime",value);
  }

  static String? getUserId(){
    return _pref.getString("userId");
  }

  static void setUserId(String userId){
    _pref.setString("userId", userId);
  }
  static String? getEmail(){
    return _pref.getString("email");
  }

  static void setEmail(String email){
    _pref.setString("email", email);
  }
  static String? getName(){
    return _pref.getString("name");
  }

  static void setName(String name){
    _pref.setString("name", name);
  }
  static String? getPhone(){
    return _pref.getString("phone");
  }

  static void setPhone(String phone){
    _pref.setString("phone", phone);
  }
  static String? getPassword(){
    return _pref.getString("password");
  }

  static void setPassword(String password){
    _pref.setString("password", password);
  }
  static String? getCountry(){
    return _pref.getString("country");
  }

  static void setEmailReset(String email){
    _pref.setString("reset", email);
  }
  static String? getEmailRest(){
    return _pref.getString("reset");
  }

  static void setCountry(String country){
    _pref.setString("country", country);
  }

  static void setAvatar(String avatar){
    _pref.setString("avatar", avatar);
  }
  static String? getAvatar(){
   // print(_pref.getString("avatar"));
    return _pref.getString("avatar");
  }
  static List<String> getLikedPlaces(){
    return _pref.getStringList("likedPlaces") ?? [];
  }

  static void setLikedPlaces(List<String> likedPlaces){
    _pref.setStringList("likedPlaces", likedPlaces);
  }
  static List<String> getLikedHotels(){
    return _pref.getStringList("likedHotels") ?? [];
  }
  static void setLikedHotels(List<String> likedHotels){
    _pref.setStringList("likedHotels", likedHotels);
  }
  static String? getStartDate(){
    return _pref.getString("startDate");
  }

  static void setStartDate(String startDate){
    _pref.setString("startDate", startDate);
  }
  static String? getEndDate(){
    return _pref.getString("endDate");
  }

  static void setEndDate(String endDate){
    _pref.setString("endDate", endDate);
  }
  static int? getDays(){
    return _pref.getInt("days");
  }

  static void setDays(int days){
    _pref.setInt("days", days);
  }
  static int? getRoom(){
    return _pref.getInt("rooms");
  }

  static void setRoom(int rooms){
    _pref.setInt("rooms", rooms);
  }
  static int? getGuest(){
    return _pref.getInt("guests");
  }

  static void setGuest(int guests){
    _pref.setInt("guests", guests);
  }
  static List<String> getListContacts(){
    return _pref.getStringList("contacts") ?? [];
  }

  static void setListContacts(List<String> contacts){
    _pref.setStringList("contacts", contacts);
  }
  static String? getTypePayment(){
    return _pref.getString("type");
  }

  static void setTypePayment(String typePayment){
    _pref.setString("type", typePayment);
  }
  static void clear(String item){
    _pref.remove(item);
  }
  static String? getCard(){
    return _pref.getString("card");
  }

  static void setCard(String card){
    _pref.setString("card",card);
  }
  static String? getPromo(){
    return _pref.getString("promo");
  }

  static void setPromo(String promo){
    _pref.setString("promo",promo);
  }
  static List<String> getListSeat(){
    return _pref.getStringList("seats") ?? [];
  }

  static void setListSeat(List<String> seats){
    _pref.setStringList("seats", seats);
  }
  static void setBookingId(String bookingId){
    _pref.setString("bookingId", bookingId);
  }
  static String? getBookingId(){
    return _pref.getString("bookingId");
  }
  static void setBookingFlightId(String bookingId){
    _pref.setString("bookingFlightId", bookingId);
  }
  static String? getBookingFlightId(){
    return _pref.getString("bookingFlightId");
  }

}
void sharedServiceClear(){
  SharedService.clear("startDate");
  SharedService.clear("endDate");
  SharedService.clear("guest");
  SharedService.clear("rooms");
  SharedService.clear("contacts");
  SharedService.clear("type");
  SharedService.clear("card");
  SharedService.clear("promo");
  SharedService.clear('days');
  SharedService.clear("bookingId");
  SharedService.clear("bookingFlightId");
}