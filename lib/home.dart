import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:androidmap/drawer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
bool canAddPolygonPoints = false;
bool canAddPolylinePoints = false;
bool canAddCirclePoints = false;

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



  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _marker = _markers[_markerIndex];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
    });
  }

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

  List<LatLng> polygonPoints = <LatLng>[];
  List<LatLng> polylinePoints = <LatLng>[];
  List<CircleMarker> circleMarkers = <CircleMarker>[];

  // CircleMarker(
  // point: Tehran,
  // color: Colors.blue.withOpacity(0.7),
  // borderStrokeWidth: 2,
  // useRadiusInMeter: true,
  // radius: 2000 // 2000 meters | 2 km
  // )

  var mapURL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  TextEditingController mapURLController = TextEditingController();

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
                    print("set map state: ${mapURLController.text}");
                    mapURL = mapURLController.text;
                    // codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  String? codeDialog;
  String? valueText;

  @override
  Widget build(BuildContext context) {
    // final markers = <Marker>[
    //   Marker(
    //     width: 80,
    //     height: 80,
    //     point: Tehran,
    //     builder: (ctx) => Container(
    //       key: const Key('blue'),
    //       child: const FlutterLogo(),
    //     ),
    //   ),
    // ];

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //     leading: MaterialButton(
      //       hoverColor: Colors.white,
      //       onPressed: () {
      //         _scaffoldKey.currentState?.openDrawer();
      //       },
      //       child: const Icon(Icons.menu),
      //     )),
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
                    initialCenter: const LatLng(34.98458815562796, 53.00772564862618),
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

                          // CircleMarker(
                          //     point: Tehran,
                          //     color: Colors.blue.withOpacity(0.7),
                          //     borderStrokeWidth: 2,
                          //     useRadiusInMeter: true,
                          //     radius: 2000 // 2000 meters | 2 km
                          // )

                          setState(() {
                            circleMarkers.add(
                                CircleMarker(
                                point: LatLng(point.latitude, point.longitude),
                                color: Colors.blue.withOpacity(0.7),
                                borderStrokeWidth: 2,
                                useRadiusInMeter: true,
                                radius: 2000 // 2000 meters | 2 km
                            )
                            );
                          })
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
                          },
                          child: const Icon(Icons.compass_calibration_rounded),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 2, top: 60, right: 2),
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
                    // MarkerLayer(markers: markers),
                    MarkerLayer(markers: [_marker!]),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: Row(children: [
              //     Expanded(child: TextField(controller: mapURLController)),
              //     ElevatedButton(
              //         onPressed: () {
              //           setState(() {
              //             print("set map state: ${mapURLController.text}");
              //             mapURL = mapURLController.text;
              //           });
              //         },
              //         child: const Text("Ok"))
              //   ]),
              // ),
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


List<Marker> _markers = [
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(25.33659029478394, 55.37202949758635),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(27.08522258957233, 56.41065885605138),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(28.076655615654232, 54.557242673273265),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(29.05902134066427, 52.959270323586225),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(30.667313538077476, 52.22401343493653),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(31.515680503932543, 52.22401343493653),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(32.93500782951779, 51.776855054948314),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(33.80230476291638, 51.66467044371453),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(34.41084675545238 , 51.10585414080813),
    builder: (ctx) => const Icon(Icons.airplanemode_active_sharp),
  ),
  Marker(
    width: 150,
    height: 150,
    point: const LatLng(35.6273636576352, 51.297568687705294),
    builder: (ctx) => const Icon(Icons.airplanemode_active_outlined),
  ),
];