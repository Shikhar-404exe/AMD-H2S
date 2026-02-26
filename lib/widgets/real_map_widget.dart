import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../models/issue_model.dart';

class RealMapWidget extends StatefulWidget {
  final List<IssueModel> issues;
  final Function(IssueModel)? onIssueSelected;
  final LatLng? initialPosition;

  const RealMapWidget({
    super.key,
    this.issues = const [],
    this.onIssueSelected,
    this.initialPosition,
  });

  @override
  State<RealMapWidget> createState() => _RealMapWidgetState();
}

class _RealMapWidgetState extends State<RealMapWidget> {
  GoogleMapController? _controller;
  final LocationService _locationService = LocationService();
  LatLng _center = const LatLng(28.6139, 77.2090);
  final Set<Marker> _markers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _createMarkers();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialPosition != null) {
      _center = widget.initialPosition!;
      setState(() => _loading = false);
      return;
    }

    Position? position = await _locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  void _createMarkers() {
    _markers.clear();

    for (var issue in widget.issues) {
      _markers.add(
        Marker(
          markerId: MarkerId(issue.id),
          position: LatLng(issue.latitude, issue.longitude),
          infoWindow: InfoWindow(
            title: issue.title,
            snippet: issue.category,
            onTap: () {
              if (widget.onIssueSelected != null) {
                widget.onIssueSelected!(issue);
              }
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(issue.priorityScore),
          ),
        ),
      );
    }
  }

  double _getMarkerColor(double priority) {
    if (priority >= 0.8) return BitmapDescriptor.hueRed;
    if (priority >= 0.5) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueGreen;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 13,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      onTap: (LatLng position) {},
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
