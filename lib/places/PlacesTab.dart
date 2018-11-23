import 'package:flutter/material.dart';
import 'package:near_way/places/PlaceModel.dart';
import 'package:near_way/places/PlacesService.dart';
import 'package:location/location.dart';

class PlacesTab extends StatefulWidget {
  @override
  PlacesTabState createState() => new PlacesTabState();
}

class PlacesTabState extends State<PlacesTab> {
  Map<String, double> _currentlocation = new Map();

  Location location = new Location();
  List<PlaceDetail> _places;

  void handleItemTap(PlaceDetail place) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => PlacesDetail()));
  }

  @override
  void initState() {
    super.initState();
    _currentlocation['latitude'] = 0.0;
    _currentlocation['longitude'] = 0.0;

    if (_places == null && mounted) {
      location.getLocation().then((onValue) {
        print(onValue);
        _currentlocation = onValue;
        LocationService.set(onValue['latitude'], onValue['longitude']);
        LocationService.get().getNearbyPlaces().then((data) {
          setState(() {
            _places = data;
          });
        });
      });
    }
  }

  String _currentPlaceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _places == null
            ? new Center(child: CircularProgressIndicator())
            : new ListView(
                children: _places.map((f) {
                  return new ListTile(
                    title: Text(f.name),
                    subtitle: Text(f.vicinity),
                    onTap: () {
                      _currentPlaceId = f.id;
                      handleItemTap(f);
                    },
                  );
                }).toList(),
              ));
  }
}
