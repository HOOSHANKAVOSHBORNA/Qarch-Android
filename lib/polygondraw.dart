// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'drawer.dart';
//
// class PolygonDrawPage extends StatefulWidget {
//   static const String route = 'map_controller';
//
//   const PolygonDrawPage({Key? key}) : super(key: key);
//
//   @override
//   PolygonDrawPageState createState() {
//     return PolygonDrawPageState();
//   }
// }
//
// class PolygonDrawPageState extends State<PolygonDrawPage>
//     with TickerProviderStateMixin {
//   static const _startedId = 'AnimatedMapController#MoveStarted';
//   static const _inProgressId = 'AnimatedMapController#MoveInProgress';
//   static const _finishedId = 'AnimatedMapController#MoveFinished';
//   late final MapController _mapController;
//
//   static const LatLng Tehran = LatLng(35.710680, 51.378152);
//   double _rotation = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//   }
//
//   void _animatedMapMove(LatLng destLocation, double destZoom) {
//     // Create some tweens. These serve to split up the transition from one location to another.
//     // In our case, we want to split the transition be<tween> our current map center and the destination.
//     final camera = _mapController.camera;
//     final latTween = Tween<double>(
//         begin: camera.center.latitude, end: destLocation.latitude);
//     final lngTween = Tween<double>(
//         begin: camera.center.longitude, end: destLocation.longitude);
//     final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);
//
//     // Create a animation controller that has a duration and a TickerProvider.
//     final controller = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     // The animation determines what path the animation will take. You can try different Curves values, although I found
//     // fastOutSlowIn to be my favorite.
//     final Animation<double> animation =
//     CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
//
//     // Note this method of encoding the target destination is a workaround.
//     // When proper animated movement is supported (see #1263) we should be able
//     // to detect an appropriate animated movement event which contains the
//     // target zoom/center.
//     final startIdWithTarget =
//         '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
//     bool hasTriggeredMove = false;
//
//     controller.addListener(() {
//       final String id;
//       if (animation.value == 1.0) {
//         id = _finishedId;
//       } else if (!hasTriggeredMove) {
//         id = startIdWithTarget;
//       } else {
//         id = _inProgressId;
//       }
//
//       hasTriggeredMove |= _mapController.move(
//         LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
//         zoomTween.evaluate(animation),
//         id: id,
//       );
//     });
//
//     animation.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         controller.dispose();
//       } else if (status == AnimationStatus.dismissed) {
//         controller.dispose();
//       }
//     });
//
//     controller.forward();
//   }
//
//   List<LatLng> polygonPoints = <LatLng>[];
//
//   @override
//   Widget build(BuildContext context) {
//     // final markers = <Marker>[
//     //   Marker(
//     //     width: 80,
//     //     height: 80,
//     //     point: Tehran,
//     //     builder: (ctx) => Container(
//     //       key: const Key('blue'),
//     //       child: const FlutterLogo(),
//     //     ),
//     //   ),
//     // ];
//
//     GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
//
//     return Scaffold(
//       // backgroundColor: Colors.deepOrange,
//       // appBar: AppBar(
//       //     // backgroundColor: Colors.black45,
//       //     title: const Text('Houshan Map')),
//       key: scaffoldState,
//       // drawer: DrawerView(),
//       drawer: buildDrawer(context, PolygonDrawPage.route),
//       body: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Column(
//           children: [
//             Flexible(
//               child: FlutterMap(
//                 mapController: _mapController,
//                 options: MapOptions(
//                   initialCenter: const LatLng(35.710680, 51.378152),
//                   initialZoom: 5,
//                   maxZoom: 15,
//                   minZoom: 3,
//                   onTap: (tapPosition, point) => {
//                     print(
//                         "latitude is: ${point.latitude} longitude is: ${point.longitude}"),
//                     setState(() {
//                       polygonPoints.add(point);
//                     }),
//                   },
//                 ),
//                 nonRotatedChildren: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 2, top: 60, right: 2),
//                       child: FloatingActionButton(
//                         heroTag: 'menu',
//                         mini: true,
//                         backgroundColor: Colors.black26,
//                         foregroundColor: Colors.deepOrange,
//                         hoverColor: Colors.black26,
//                         onPressed: () {
//                           scaffoldState.currentState?.openDrawer();
//                         },
//                         child: const Icon(Icons.menu),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 2, top: 60, right: 2),
//                       child: FloatingActionButton(
//                         heroTag: 'compass',
//                         mini: true,
//                         backgroundColor: Colors.black26,
//                         foregroundColor: Colors.deepOrange,
//                         hoverColor: Colors.black26,
//                         onPressed: () {
//                           _mapController.rotate(0);
//                         },
//                         child: const Icon(Icons.compass_calibration_rounded),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: FloatingActionButton(
//                             heroTag: 'home',
//                             mini: true,
//                             backgroundColor: Colors.black26,
//                             foregroundColor: Colors.deepOrange,
//                             hoverColor: Colors.black26,
//
//                             onPressed: () {
//                               _animatedMapMove(Tehran, 10);
//                             },
//                             child: const Icon(Icons.home_filled),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: FloatingActionButton(
//                             heroTag: 'clear',
//                             mini: true,
//                             backgroundColor: Colors.black26,
//                             foregroundColor: Colors.deepOrange,
//                             hoverColor: Colors.black26,
//                             onPressed: () {
//                               setState(() {
//                                 polygonPoints.clear();
//                               });
//                             },
//                             child: const Icon(Icons.cleaning_services_rounded),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsets.only(left: 2, top: 2, right: 2),
//                           child: FloatingActionButton(
//                             heroTag: 'zoomInButton',
//                             mini: true,
//                             backgroundColor: Colors.black26,
//                             foregroundColor: Colors.white,
//                             hoverColor: Colors.black26,
//                             onPressed: () {
//                               final paddedMapCamera = CameraFit.bounds(
//                                 bounds: _mapController.camera.visibleBounds,
//                                 padding: const EdgeInsets.all(12),
//                               ).fit(_mapController.camera);
//                               var zoom = paddedMapCamera.zoom + 1;
//                               if (zoom > 18) {
//                                 zoom = 18;
//                               }
//                               _mapController.move(paddedMapCamera.center, zoom);
//                             },
//                             child: const Icon(Icons.zoom_in),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: FloatingActionButton(
//                             heroTag: 'zoomOutButton',
//                             mini: true,
//                             backgroundColor: Colors.black26,
//                             foregroundColor: Colors.white,
//                             hoverColor: Colors.black26,
//                             onPressed: () {
//                               final paddedMapCamera = CameraFit.bounds(
//                                 bounds: _mapController.camera.visibleBounds,
//                                 padding: const EdgeInsets.all(12),
//                               ).fit(_mapController.camera);
//                               var zoom = paddedMapCamera.zoom - 1;
//                               if (zoom < 1) {
//                                 zoom = 1;
//                               }
//                               _mapController.move(paddedMapCamera.center, zoom);
//                             },
//                             child: const Icon(Icons.zoom_out),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                     'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     // 'https://api.gitanegaran.ir/sat/{z}/{x}/{y}.jpg',
//                     tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
//                   ),
//                   PolygonLayer(
//                     polygons: [
//                       Polygon(
//                         points: polygonPoints,
//                         isFilled: false, // By default it's false
//                         borderColor: Colors.deepPurple,
//                         borderStrokeWidth: 4,
//                       ),
//                     ],
//                   )
//                   // MarkerLayer(markers: markers),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 1, bottom: 1, left: 12),
//               child: Row(
//                 children: <Widget>[
//                   // MaterialButton(
//                   //   onPressed: () {
//                   //     _animatedMapMove(Tehran, 10);
//                   //   },
//                   //   child: const Icon(Icons.home_filled),
//                   //   // const Text('Tehran'),
//                   // ),
//                   // MaterialButton(
//                   //   onPressed: () {
//                   //     final bounds = LatLngBounds.fromPoints([
//                   //       london,
//                   //     ]);
//                   //     final constrained = CameraFit.bounds(
//                   //       bounds: bounds,
//                   //     ).fit(_mapController.camera);
//                   //     _animatedMapMove(constrained.center, constrained.zoom);
//                   //   },
//                   //   child: const Text('Fit Bounds animated'),
//                   // ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 2, bottom: 2),
//                   //   child: Row(
//                   //     children: <Widget>[
//                   // Builder(builder: (BuildContext context) {
//                   //   return MaterialButton(
//                   //     onPressed: () {
//                   //       _mapController.rotate(0);
//                   //     },
//                   //     child: const Icon(Icons.compass_calibration_rounded),
//                   //     // const Text('Compass'),
//                   //   );
//                   // }),
//                   const Text('Rotation:'),
//                   Expanded(
//                     child: Slider(
//                       value: _rotation,
//                       thumbColor: Colors.grey,
//                       activeColor: Colors.deepOrange,
//                       min: 0,
//                       max: 360,
//                       onChanged: (degree) {
//                         setState(() {
//                           _rotation = degree;
//                         });
//                         _mapController.rotate(degree);
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             // ElevatedButton(onPressed: () {
//             //   setState(() {
//             //     polygonPoints.clear();
//             //   });
//             // },
//             //     child: const Text("Clear pol"))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Causes tiles to be prefetched at the target location and disables pruning
// /// whilst animating movement. When proper animated movement is added (see
// /// #1263) we should just detect the appropriate AnimatedMove events and
// /// use their target zoom/center.
// final _animatedMoveTileUpdateTransformer =
// TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
//   final mapEvent = updateEvent.mapEvent;
//
//   final id = mapEvent is MapEventMove ? mapEvent.id : null;
//   if (id?.startsWith(PolygonDrawPageState._startedId) == true) {
//     final parts = id!.split('#')[2].split(',');
//     final lat = double.parse(parts[0]);
//     final lon = double.parse(parts[1]);
//     final zoom = double.parse(parts[2]);
//
//     // When animated movement starts load tiles at the target location and do
//     // not prune. Disabling pruning means existing tiles will remain visible
//     // whilst animating.
//     sink.add(
//       updateEvent.loadOnly(
//         loadCenterOverride: LatLng(lat, lon),
//         loadZoomOverride: zoom,
//       ),
//     );
//   } else if (id == PolygonDrawPageState._inProgressId) {
//     // Do not prune or load whilst animating so that any existing tiles remain
//     // visible. A smarter implementation may start pruning once we are close to
//     // the target zoom/location.
//   } else if (id == PolygonDrawPageState._finishedId) {
//     // We already prefetched the tiles when animation started so just prune.
//     sink.add(updateEvent.pruneOnly());
//   } else {
//     sink.add(updateEvent);
//   }
// });
