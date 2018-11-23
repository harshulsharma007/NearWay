import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:near_way/places/PlaceModel.dart';
import 'dart:async';

class LocationService
{

  static var lon;
  static var lat;

  static final _locationService = new LocationService();


  static LocationService get() {
    return _locationService;
  }

  static void set(double longitude, double latitude){
    lon = longitude;
    lat = latitude;
  }

  final String detailUrl = "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyCZvqa0dfN6w2BPvZiQVUD3-30DTLsNpEY&placeid=";


  Future<List<PlaceDetail>> getNearbyPlaces() async {
    var url="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lon,$lat&radius=5000&type=restaurant&key=AIzaSyCZvqa0dfN6w2BPvZiQVUD3-30DTLsNpEY";
    var reponse = await http.get(url, headers: {"Accept": "application/json"});

    List data = json.decode(reponse.body)["results"];
    var places = <PlaceDetail>[];
    data.forEach((f) => places.add(new PlaceDetail(f["place_id"], f["name"], f["icon"], f["rating"].toString(), f["vicinity"])));
    return places;
  }

  Future getPlace(String place_id) async{
    var response = await http.get(detailUrl+place_id, headers: {"Accept": "application/json"});
    var result = json.decode(response.body)["result"];

    List<String> weekdays = [];
    if (result["opening_hours"] != null)
      weekdays = result["opening_hours"]["weekday_text"];
    return new PlaceDetail(
        result["place_id"],
        result["name"],
        result["icon"],
        result["rating"].toString(),
        result["vicinity"],
        result["formatted_address"],
        result["international_phone_number"],
        weekdays);
  }
}