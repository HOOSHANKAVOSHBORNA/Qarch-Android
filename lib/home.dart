// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:androidmap/drawer.dart';

// import 'dart:math';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

bool canAddPolygonPoints = false;
bool canAddPolylinePoints = false;
bool canAddCirclePoints = false;

bool showAirplaneMarkers = false;
bool showShipMarkers = false;
bool showAircraftMarkers = false;
bool showMissileMarkers = false;

class MapControllerPage extends StatefulWidget {
  static const String route = 'map_controller';

  const MapControllerPage({Key? key}) : super(key: key);

  @override
  MapControllerPageState createState() {
    return MapControllerPageState();
  }
}

class MapControllerPageState extends State<MapControllerPage>
    with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';
  late final MapController _mapController;

  static const LatLng Tehran = LatLng(35.710680, 51.378152);
  double _rotation = 0;

  Marker? _marker;
  late final Timer _timer;
  int _markerIndex = 0;

  // List<Widget Function(BuildContext)> _markerAngles = [];

  List<LatLng> polygonPoints = <LatLng>[];
  List<LatLng> polylinePoints = <LatLng>[];
  List<CircleMarker> circleMarkers = <CircleMarker>[];
  final List<Marker> _markers = [
    Marker(
        width: 150,
        height: 150,
        // rotate: true,
        point: const LatLng(25.118081125977074, 55.271777924952886),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(0 / 360),
              child: Image.asset('images/takeoff.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(25.43366916259446, 55.44214636678984),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(25 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(25.748432715240575, 55.62093499520853),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(20 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(25.986223587605352, 55.65489641442151),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(15 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(26.299520682698788, 55.70597887968402),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(10 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(26.5664050330863, 55.65489641442151),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(5 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(26.923574743788045, 55.35682180942834),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(27.242220242545827, 55.09298929653415),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(27.627698133675423, 55.00766473917265),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(350 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(27.966825925729225, 54.658507668916954),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(345 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(28.199458404321955, 54.164804062341595),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(340 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(28.401880714953673, 53.951773341823866),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(335 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(28.708427860869524, 53.45778906236246),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(330 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(29.096435425112706, 53.287701293411516),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(325 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(29.356536499471456, 53.074670572893794),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(330 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(29.73438340946106, 52.989626688418305),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(335 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(30.088769279639536, 52.84479947921258),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(340 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(30.39028041113446, 52.81083805999961),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(345 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(30.844621562665917, 52.58068629343235),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(350 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(31.070736503927986, 52.54672487421938),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(350 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(31.442020484971895, 52.376356432382416),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(350 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(31.695956218765957, 52.3168537805382),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(32.072295753208735, 52.282892361325224),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(32.41058309248153, 51.96769671028252),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(32.855186852686245, 51.93373529106954),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(33.07690658112279, 51.848410733708036),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(33.36886134551975, 51.848410733708036),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(33.73082957011309, 51.70358352450227),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(355 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(34.020586719265694, 51.58457822081388),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(0 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(34.34458998106719, 51.40578959239515),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(0 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(34.674655878412885, 51.26938256977113),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(5 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(34.891218248276594, 51.141676406614906),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(10 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(35.10769601535921, 51.141676406614906),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(15 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(35.28152954338103, 51.26938256977113),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(20 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
        width: 150,
        height: 150,
        point: const LatLng(35.46223026717949, 51.26938256977113),
        builder: (ctx) => RotationTransition(
              turns: const AlwaysStoppedAnimation(30 / 360),
              child: Image.asset('images/plane.png'),
            )),
    Marker(
      width: 150,
      height: 150,
      point: const LatLng(35.75272062203071, 51.320465035033635),
      builder: (ctx) => Image.asset('images/arrival.png'),
    ),
  ];
  final shipMarkers = <Marker>[
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(42.38617967163965, 50.17888270526124),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(5 / 360),
        child: Image.asset('images/cruise.png'),
      ),
    ),
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(38.496181843864626, 51.472955896817304),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(0 / 360),
        child: Image.asset('images/cruise.png'),
      ),
    ),
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(26.272532193658027, 52.39992733236418),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(0 / 360),
        child: Image.asset('images/cruise.png'),
      ),
    ),
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(24.932939540053855, 58.04075919299317),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(0 / 360),
        child: Image.asset('images/cruise.png'),
      ),
    ),
  ];
  final aircraftMarkers = <Marker>[
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(28.344147117338782, 47.94151074037312),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(35 / 360),
        child: Image.asset('images/jet.png'),
      ),
    ),
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(38.01947346263611, 56.93840054833429),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(250 / 360),
        child: Image.asset('images/jet.png'),
      ),
    ),
  ];
  final missileMarkers = <Marker>[
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(34.93664035092929, 46.82282475792903),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(290 / 360),
        child: Image.asset('images/missile.png'),
      ),
    ),
    Marker(
      width: 80,
      height: 80,
      point: const LatLng(33.788444470019336, 59.91050271355647),
      builder: (ctx) => RotationTransition(
        turns: const AlwaysStoppedAnimation(0 / 360),
        child: Image.asset('images/missile.png'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    // calculateAngles();
    _marker = _markers[_markerIndex];
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
    });
  }

  //Markers draggable and dynamically loaded
  // calculateAngles() {
  //   var tempMarker = _markers[0];
  //   for (var i = 1; i < _markers.length; i++) {
  //     _markerAngles.add((ctx) =>
  //         RotationTransition(
  //           turns: AlwaysStoppedAnimation(calculateAngle(
  //               tempMarker.point.latitude,
  //               tempMarker.point.longitude,
  //               _markers[i].point.latitude,
  //               _markers[i].point.longitude)),
  //           child: Image.asset('images/plane.png'),
  //         ));
  //     _markers[i].builder
  //   . = _markerAngles[i];
  //   tempMarker = _markers[i
  //   ];
  // }
  // }

  // double calculateAngle(double lat1, double lon1, double lat2, double lon2) {
  //   const earthRadius = 6371.0; // Radius of the Earth in kilometers
  //
  //   // Convert latitude and longitude from degrees to radians
  //   final lat1Rad = degToRadian(lat1);
  //   final lon1Rad = degToRadian(lon1);
  //   final lat2Rad = degToRadian(lat2);
  //   final lon2Rad = degToRadian(lon2);
  //
  //   // Calculate the differences
  //   final dLat = lat2Rad - lat1Rad;
  //   final dLon = lon2Rad - lon1Rad;
  //
  //   // Use Haversine formula to calculate the angle
  //   final a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //
  //   // Calculate the angle in degrees
  //   final angle = c * earthRadius;
  //
  //   // Convert angle from radians to degrees
  //   final angleDegrees = angle * (180 / pi);
  //
  //   return angleDegrees;
  // }

  // void main() {
  //   double lat1 = 37.7749; // Latitude of the first point
  //   double lon1 = -122.4194; // Longitude of the first point
  //   double lat2 = 34.0522; // Latitude of the second point
  //   double lon2 = -118.2437; // Longitude of the second point
  //
  //   double angle = calculateAngle(lat1, lon1, lat2, lon2);
  //
  //   print('Angle between the two points: $angle degrees');
  // }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  var mapURL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  TextEditingController mapURLController = TextEditingController();

  String? valueText;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black26,
            title: const Text('Add MAp URL'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: mapURLController,
              decoration: const InputDecoration(hintText: "Input Map URL Here"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    // print("set map state: ${mapURLController.text}");
                    mapURL = mapURLController.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(context, MapControllerPage.route),
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        const LatLng(34.98458815562796, 53.00772564862618),
                    initialZoom: 5,
                    maxZoom: 15,
                    minZoom: 3,
                    onTap: (tapPosition, point) => {
                      print(
                          "latitude is: ${point.latitude} longitude is: ${point.longitude}"),
                      if (canAddPolygonPoints)
                        {
                          setState(() {
                            polygonPoints.add(point);
                          })
                        },
                      if (canAddPolylinePoints)
                        {
                          setState(() {
                            polylinePoints.add(point);
                          })
                        },
                      if (canAddCirclePoints)
                        {
                          setState(
                            () {
                              circleMarkers.add(
                                CircleMarker(
                                    point:
                                        LatLng(point.latitude, point.longitude),
                                    color: Colors.blue.withOpacity(0.7),
                                    borderStrokeWidth: 2,
                                    useRadiusInMeter: true,
                                    radius: 5000 // 5000 meters | 5 km
                                    ),
                              );
                            },
                          ),
                        }
                      else
                        {},
                    },
                  ),
                  nonRotatedChildren: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 2, top: 60, right: 2),
                        child: FloatingActionButton(
                          heroTag: 'menu',
                          mini: true,
                          backgroundColor: Colors.black26,
                          foregroundColor: Colors.deepOrange,
                          hoverColor: Colors.black26,
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: const Icon(Icons.menu),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 2, top: 60, right: 2),
                        child: FloatingActionButton(
                          heroTag: 'compass',
                          mini: true,
                          backgroundColor: Colors.black26,
                          foregroundColor: Colors.deepOrange,
                          hoverColor: Colors.black26,
                          onPressed: () {
                            _mapController.rotate(0);
                            _rotation = 0;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Transform.rotate(
                              angle: _rotation / 60,
                              child: Image.asset('images/compass.png'),
                            ),
                          ),
                          // child: const Icon(Icons.compass_calibration_rounded),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: FloatingActionButton(
                              heroTag: 'MapURL',
                              mini: true,
                              backgroundColor: Colors.black26,
                              foregroundColor: Colors.deepOrange,
                              hoverColor: Colors.black26,
                              onPressed: () {
                                _displayTextInputDialog(context);
                              },
                              child: const Icon(Icons.maps_ugc_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: FloatingActionButton(
                              heroTag: 'home',
                              mini: true,
                              backgroundColor: Colors.black26,
                              foregroundColor: Colors.deepOrange,
                              hoverColor: Colors.black26,
                              onPressed: () {
                                _animatedMapMove(Tehran, 10);
                              },
                              child: const Icon(Icons.home_filled),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: FloatingActionButton(
                              heroTag: 'clear',
                              mini: true,
                              backgroundColor: Colors.black26,
                              foregroundColor: Colors.deepOrange,
                              hoverColor: Colors.black26,
                              onPressed: () {
                                setState(() {
                                  polygonPoints.clear();
                                  polylinePoints.clear();
                                  circleMarkers.clear();
                                });
                              },
                              child:
                                  const Icon(Icons.cleaning_services_rounded),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2, top: 2, right: 2),
                            child: FloatingActionButton(
                              heroTag: 'zoomInButton',
                              mini: true,
                              backgroundColor: Colors.black26,
                              foregroundColor: Colors.white,
                              hoverColor: Colors.black26,
                              onPressed: () {
                                final paddedMapCamera = CameraFit.bounds(
                                  bounds: _mapController.camera.visibleBounds,
                                  padding: const EdgeInsets.all(12),
                                ).fit(_mapController.camera);
                                var zoom = paddedMapCamera.zoom + 1;
                                if (zoom > 18) {
                                  zoom = 18;
                                }
                                _mapController.move(
                                    paddedMapCamera.center, zoom);
                              },
                              child: const Icon(Icons.zoom_in),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: FloatingActionButton(
                              heroTag: 'zoomOutButton',
                              mini: true,
                              backgroundColor: Colors.black26,
                              foregroundColor: Colors.white,
                              hoverColor: Colors.black26,
                              onPressed: () {
                                final paddedMapCamera = CameraFit.bounds(
                                  bounds: _mapController.camera.visibleBounds,
                                  padding: const EdgeInsets.all(12),
                                ).fit(_mapController.camera);
                                var zoom = paddedMapCamera.zoom - 1;
                                if (zoom < 1) {
                                  zoom = 1;
                                }
                                _mapController.move(
                                    paddedMapCamera.center, zoom);
                              },
                              child: const Icon(Icons.zoom_out),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate: mapURL,
                      // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // 'https://api.gitanegaran.ir/sat{z}/{x}/{y}.jpg',
                      tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
                      backgroundColor: Colors.transparent,
                    ),
                    PolygonLayer(
                      polygons: [
                        Polygon(
                          points: polygonPoints,
                          isFilled: false, // By default it's false
                          borderColor: Colors.deepPurple,
                          borderStrokeWidth: 4,
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: polylinePoints,
                          strokeWidth: 5,
                          color: Colors.blue.withOpacity(0.6),
                          borderStrokeWidth: 5,
                          borderColor: Colors.red.withOpacity(0.4),
                        ),
                      ],
                    ),
                    CircleLayer(
                      circles: circleMarkers,
                    ),
                    showAirplaneMarkers == true
                        ? MarkerLayer(
                            markers: [_marker!],
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    showShipMarkers == true
                        ? MarkerLayer(
                            markers: shipMarkers,
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    showAircraftMarkers == true
                        ? MarkerLayer(
                            markers: aircraftMarkers,
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    showMissileMarkers == true
                        ? MarkerLayer(
                            markers: missileMarkers,
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1, left: 12),
                child: Row(
                  children: <Widget>[
                    const Text('Rotation:'),
                    Expanded(
                      child: Slider(
                        value: _rotation,
                        thumbColor: Colors.grey,
                        activeColor: Colors.deepOrange,
                        min: 0,
                        max: 360,
                        onChanged: (degree) {
                          setState(() {
                            _rotation = degree;
                          });
                          _mapController.rotate(degree);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

final _animatedMoveTileUpdateTransformer =
    TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(MapControllerPageState._startedId) == true) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == MapControllerPageState._inProgressId) {
  } else if (id == MapControllerPageState._finishedId) {
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
