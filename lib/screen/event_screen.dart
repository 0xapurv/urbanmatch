import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:urbanmatch/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import '../controllers/event_controller.dart';
import '../model/event.dart';
import '../utils/app_const.dart';

// Add an enum for filter type
enum EventFilterType { all, upcoming, past }

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final controller = Get.put(EventController());
  final Random _random = Random();
  GoogleMapController? _mapController;

  // Relevant icons for each event index
  final List<IconData> eventIcons = [
    Icons.self_improvement, // Sunset Yoga in the Park
    Icons.code,             // Tech Meetup: Flutter vs React Native
    Icons.music_note,       // Live Music @ Downtown Café
    Icons.terrain,          // Hiking Group - Morning Trail
  ];

  List<LatLng> eventLatLngs = [];
  BitmapDescriptor? dotMarker;
  int? selectedIndex;
  double currentZoom = 5;
  bool showUpcoming = true;

  // Add an enum for filter type
  EventFilterType filterType = EventFilterType.upcoming;

  LatLng _getRandomLatLng() {
    double lat = 20 + _random.nextDouble() * 10; // 20 to 30
    double lng = 70 + _random.nextDouble() * 10; // 70 to 80
    return LatLng(lat, lng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(darkMapStyle);
  }

  void _generateLatLngsIfNeeded() {
    final count = controller.eventList.length;
    if (eventLatLngs.length != count) {
      eventLatLngs = List<LatLng>.generate(count, (_) => _getRandomLatLng());
    }
  }

  Future<BitmapDescriptor> _getDotMarker() async {
    if (dotMarker != null) return dotMarker!;
    final marker = BitmapDescriptor.fromBytes(
      await _createDotMarkerBitmap(48, AppColors.markerOrange),
    );
    dotMarker = marker;
    return marker;
  }

  Future<Uint8List> _createDotMarkerBitmap(int size, Color color) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint);
    final img = await recorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _getDotMarker(); // Pre-cache dot marker
  }

  List<Event> get _filteredEvents {
    final now = DateTime.now();
    switch (filterType) {
      case EventFilterType.upcoming:
        return controller.eventList.where((event) => event.eventDateTime.isAfter(now)).toList();
      case EventFilterType.past:
        return controller.eventList.where((event) => event.eventDateTime.isBefore(now)).toList();
      case EventFilterType.all:
      default:
        return controller.eventList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Top right filter button
          Obx(() {
            _generateLatLngsIfNeeded();
            final hasEvents = _filteredEvents.isNotEmpty;
            return FutureBuilder<BitmapDescriptor>(
              future: _getDotMarker(),
              builder: (context, snapshot) {
                final dot = snapshot.data ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(25.0, 75.0),
                    zoom: 5,
                  ),
                  onCameraMove: (position) {
                    setState(() {
                      currentZoom = position.zoom;
                    });
                  },
                  markers: hasEvents
                      ? Set<Marker>.from(List.generate(_filteredEvents.length, (index) {
                          final event = _filteredEvents[index];
                          final isSelected = selectedIndex == index && currentZoom >= 12;
                          return Marker(
                            markerId: MarkerId(event.eventName),
                            position: eventLatLngs[controller.eventList.indexOf(event)],
                            icon: isSelected
                                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
                                : dot,
                            infoWindow: InfoWindow(title: event.eventName),
                          );
                        }))
                      : {},
                  mapType: MapType.normal,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                );
              },
            );
          }),
          DraggableScrollableSheet(
            minChildSize: 0.4,
            initialChildSize: 0.4,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Obx(() {
                  _generateLatLngsIfNeeded();
                  final isLoading = controller.isEventLoading.value;
                  final hasEvents = _filteredEvents.isNotEmpty;
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.markerOrange));
                  } else if (hasEvents) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        Event event = _filteredEvents[index];
                        final originalIndex = controller.eventList.indexOf(event);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.markerOrange,
                            child: Icon(
                              eventIcons.length > originalIndex ? eventIcons[originalIndex] : Icons.event,
                              color: AppColors.creme,
                            ),
                          ),
                          title: Text(
                            event.eventName,
                            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            DateFormat.jm().format(event.eventDateTime),
                            style: TextStyle(color: AppColors.creme, fontSize: 14),
                          ),
                          trailing: Icon(CupertinoIcons.chevron_forward, color: AppColors.creme),
                          onTap: () async {
                            if (_mapController != null && hasEvents) {
                              setState(() {
                                selectedIndex = index;
                              });
                              await _mapController!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: eventLatLngs[originalIndex],
                                    zoom: 13,
                                    tilt: 40,
                                    bearing: 30,
                                  ),
                                ),
                                duration: Duration(milliseconds: 600),
                              );
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No events found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }),
              );
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton<EventFilterType>(
                icon: Icon(Icons.filter_list, color: AppColors.creme),
                color: Colors.black,
                onSelected: (value) {
                  setState(() {
                    filterType = value;
                    selectedIndex = null;
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: EventFilterType.all,
                    child: Text('All', style: TextStyle(color: AppColors.creme)),
                  ),
                  PopupMenuItem(
                    value: EventFilterType.upcoming,
                    child: Text('Upcoming', style: TextStyle(color: AppColors.creme)),
                  ),
                  PopupMenuItem(
                    value: EventFilterType.past,
                    child: Text('Past', style: TextStyle(color: AppColors.creme)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


