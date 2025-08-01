import 'package:etms/app/config/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class CheckInOutMapView extends StatelessWidget {
  double lat;
  double lon;
  bool isLocationMatch;
  CheckInOutMapView({super.key, required this.lat, required this.lon, required this.isLocationMatch});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return Column(
      children: [
        Text('Check IN / OUT is allowed only in the designated area').paddingOnly(top: 20,bottom: 20),

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
                    radius: 2000,
                    useRadiusInMeter: true,
                    color: isLocationMatch?Color(0xff04FF2C).withOpacity(0.25):ColorResources.red.withOpacity(0.25),
                    borderColor: isLocationMatch?Color(0xff04FF2C).withOpacity(0.25):ColorResources.red.withOpacity(0.25),
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
