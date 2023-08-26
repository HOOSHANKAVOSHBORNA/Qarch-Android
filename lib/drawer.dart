import 'package:flutter/material.dart';
import 'package:androidmap/home.dart';

Widget _buildMenuItem(
  BuildContext context,
  Widget title,
  String routeName,
  String currentRoute, {
  Widget? icon,
}) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    leading: icon,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/location.png',
                height: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Houshan Map',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Houshan Kavosh Borna',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        _buildMenuItem(
          context,
          MaterialButton(
            padding: const EdgeInsets.only(right: 175),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Home'),
          ),
          MapControllerPage.route,
          currentRoute,
          icon: const Icon(Icons.home),
        ),
        const Divider(),
        _buildMenuItem(
          context,
          MaterialButton(
            padding: const EdgeInsets.only(right: 150),
            onPressed: () {
              // _animatedMapMove(Tehran, 10);
              // _displayTextInputDialog(context);
              Navigator.pop(context);
            },
            child: const Text('Add Layer'),
          ),
          MapControllerPage.route,
          currentRoute,
          icon: const Icon(Icons.layers),
        ),
        const Divider(),
        SafeArea(
            child:Column(
              children: [
                ExpansionTile(
                  title: const Text("Draw"),
                  leading: const Icon(Icons.draw), //add icon
                  childrenPadding: const EdgeInsets.only(left:60), //children padding
                  children: [
                    ListTile(
                      title: const Text("Polygon"),
                      onTap: (){
                        canAddPolygonPoints = !canAddPolygonPoints;
                        Navigator.pop(context);
                      },
                    ),

                    ListTile(
                      title: const Text("Polyline"),
                      onTap: (){
                        canAddPolylinePoints = !canAddPolylinePoints;
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Circle"),
                      onTap: (){
                        canAddCirclePoints = !canAddCirclePoints;
                        Navigator.pop(context);
                      },
                    ),

                    //more child menu
                  ],
                ),


                // ExpansionTile(
                //   title: Text("Parent Category 2"),
                //   leading: Icon(Icons.person), //add icon
                //   childrenPadding: EdgeInsets.only(left:60), //children padding
                //   children: [
                //     ListTile(
                //       title: Text("Child Category 1"),
                //       onTap: (){
                //         //action on press
                //       },
                //     ),
                //
                //     ListTile(
                //       title: Text("Child Category 2"),
                //       onTap: (){
                //         //action on press
                //       },
                //     ),
                //
                //     //more child menu
                //   ],
                // )
              ],
            )
        ),



        // const Divider(),
        // _buildMenuItem(
        //   context,
        //   MaterialButton(
        //     child: const Text('polygon Draw Mode'),
        //     onPressed: () {
        //       canAddPolygonPoints = !canAddPolygonPoints;
        //       Navigator.pop(context);
        //     },
        //   ),
        //   MapControllerPage.route,
        //   currentRoute,
        //   icon: const Icon(Icons.draw),
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Polygon Layer'),
        //   PolygonPage.route,
        //   currentRoute,
        // ),
        // ListTile(
        //   title: const Text('EPSG4326 CRS'),
        //   selected: currentRoute == EPSG4326Page.route,
        //   onTap: () {
        //     Navigator.pushReplacementNamed(context, EPSG4326Page.route);
        //   },
        // ),
        // ListTile(
        //   title: const Text('EPSG3413 CRS'),
        //   selected: currentRoute == EPSG3413Page.route,
        //   onTap: () {
        //     Navigator.pushReplacementNamed(context, EPSG3413Page.route);
        //   },
        // ),
        // const Divider(),
        // _buildMenuItem(
        //   context,
        //   const Text('Sliding Map'),
        //   SlidingMapPage.route,
        //   currentRoute,
        // ),
      ],
    ),
  );
}

