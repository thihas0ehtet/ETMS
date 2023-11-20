import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class CheckInOutMapView extends StatelessWidget {
  double lat;
  double lon;
  CheckInOutMapView({super.key, required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return Column(
      children: [
        Text('Check IN or OUT is allowed only in the designated area').paddingOnly(top: 20,bottom: 20),

        lat!=0.0 || lon!=0.0?
        SizedBox(
          height: 170,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(lat,lon),
              initialZoom: 11,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
              onTap: (_, latLng) {
                // final point = mapController.camera
                //     .latLngToScreenPoint(tappedCoords = latLng);
                // setState(() => tappedPoint = Point(point.x, point.y));
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(lat,lon), // center of 't Gooi
                    radius: 4000,
                    useRadiusInMeter: true,
                    color: Color(0xff04FF2C).withOpacity(0.2),
                    borderColor: Color(0xff04FF2C).withOpacity(0.2),
                    borderStrokeWidth: 2,
                  )
                ],
              ),
            ],
          ),
        ).paddingOnly(left: 20, right: 20):
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
