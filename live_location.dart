import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({Key? key}) : super(key: key);

  @override
  _LiveLocationState createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  //
  LatLng indiaLocation = LatLng(20.5937, 78.9629);
  late GoogleMapController mapController;
  Marker? livemarker;
  var locationPosition;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location'),
        actions: [
          // Live location Icon
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {
              showLiveLocation();
            },
          ),
        ],
      ),
      // show india map on mobile
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: indiaLocation,
          zoom: 5,
        ),

        // Google Contoller
        onMapCreated: (mapController) {
          this.mapController = mapController;
        },

        //
        markers: {
          if (livemarker != null) livemarker!,
        },
      ),
    );
  }

  Future<void> showLiveLocation() async {
    // check location service is enabled
    bool isServicedEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServicedEnabled) {
      print(' Device has no loction service');
      Geolocator.requestPermission();
    }
    // if location service is enable request to access the location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Position currentPositon = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPositon.latitude,
            currentPositon.longitude,
          ),
          zoom: 25,
        ),
      ),
    );

    livemarker = Marker(
      markerId: const MarkerId('location'),
      position: LatLng(currentPositon.latitude, currentPositon.longitude),
    );

    setState(() {
      //
    });

    // listen for change in live position
    locationPosition =
        Geolocator.getPositionStream().listen((Position newPositon) {
      livemarker = Marker(
        markerId: const MarkerId('location'),
        position: LatLng(newPositon.latitude, newPositon.longitude),
      );
    });

    setState(() {
      //
    });
  }
}
