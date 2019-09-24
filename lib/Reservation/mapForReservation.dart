import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/googleMapService.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with ChangeNotifier {
  GoogleMapController mapController;
  GoogleMapService _googleMapService = GoogleMapService();
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
   Set<Polyline> _polyline = {};
  TextEditingController location = TextEditingController();
  TextEditingController destination = TextEditingController();
  static LatLng testPosition = LatLng(7.477491, 80.619194);
  bool isCurrentLocation = false;

  static final CameraPosition _srilanka = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 10.0,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Make a Reservation'),
        ),
        body: _initialPosition == null
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        CameraPosition(target: _initialPosition, zoom: 8.0),
                    onMapCreated: onCreated,
                    compassEnabled: true,
                    onCameraMove: onCameraMove,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    polylines: _polyline,
                  ),
                  Positioned(
                    top: 40,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                      ),
                      child: TextField(
                        
                        controller: location,
                        decoration: InputDecoration(
                            suffixIcon: FlatButton(
                              child: Icon(Icons.my_location),
                              onPressed: () {
                                setState(() {
                                  isCurrentLocation = true;
                                });
                                _getUserLocation();
                              },
                            ),
                            prefixIcon: Icon(Icons.add_location),
                            hintText: 'Pickup',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 16.0)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 95,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        controller: destination,
                        onSubmitted: (value) {
                          sendRequest(value);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.directions_transit),
                            hintText: 'Destination',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 16.0)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 500,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      child: RaisedButton(
                        child: Text('Reserve'),
                        onPressed: (){},
                      ),
                    ),
                  )
                ],
              ));
  }

  List<LatLng> convertLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      //location.text = placemark[0].name;
      if (isCurrentLocation) {
        location.text = placemark[0].name;
      }
    });

    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void sendRequest(String searchLocation) async {
    String source = location.text;
    List<Placemark> sourceplacemark =
        await Geolocator().placemarkFromAddress(source);
    double sourcelatitude = sourceplacemark[0].position.latitude;
    double sourcelongtitude = sourceplacemark[0].position.longitude;
    LatLng from = LatLng(sourcelatitude, sourcelongtitude);

    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(searchLocation);
    double latitude = placemark[0].position.latitude;
    double longtitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longtitude);
    
    

    if (isCurrentLocation) {
      print('Current location :::: $_initialPosition');
      //_addMarker(_initialPosition, "Home");
      _addMarker(destination, searchLocation);
      String route = await _googleMapService.getRouteCoordinates(
          _initialPosition, destination);
      createRoute(route);
    } else {
      print('Different location');
      setState(() {
        _polyline = {};
      });
      //_addMarker(from, "Home");
      _addMarker(destination, searchLocation);
      String route =
          await _googleMapService.getRouteCoordinates(from, destination);
      createRoute(route);
    }

    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "go here"),
          icon: BitmapDescriptor.defaultMarker));
    });
    notifyListeners();
  }

  void createRoute(String encodedPolyline) {
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 5,
          color: Colors.black,
          points: convertLatLng(_decodePoly(encodedPolyline))));
    });
    notifyListeners();
  }
}
