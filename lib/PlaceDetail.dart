import 'package:flutter/material.dart';


class PlacesDetail extends StatefulWidget {
  @override
  State createState() => new PlaceDetailstate();
}

class PlaceDetailstate extends State<PlacesDetail> {

  String _currentPlaceId;
  @override
  Widget build(BuildContext context) {

    onItemTapped= ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new PlaceDetailPage(_currentPlaceId)));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Nearby places"),
        backgroundColor: Colors.blue,
      ),
      body:_createContent(),
    );
  }
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _createContent() {

    if(_places == null){
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }

    else{
      return new ListView(
        children: _places.map((f){

          return new Card(
            child: new ListTile(
                title: new Text(f.name,style: _biggerFont,),
                //leading: new Image.network(f.icon),
                subtitle: new Text(f.vicinity),
                onTap: (){
                  _currentPlaceId = f.id;
                  // onItemTapped();
                  handleItemTap(f);
                }
            ),
          )
          ;
        }).toList(),
      );
    }
  }
  List<PlaceDetail> _places;
  @override
  void initState() {
    super.initState();
    if (_places == null) {
      LocationService.get().getNearbyPlaces().then((data) {
        this.setState(() {
          _places = data;
        });
      });
    }

    //print("count: "+_places.length.toString());
  }

  handleItemTap(PlaceDetail place){

    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new PlaceDetailPage(place.id)));
  }

  VoidCallback onItemTapped;
}
