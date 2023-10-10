import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:viacep/components/card_count.dart';
import 'package:viacep/model/coordinate.dart';
import 'package:viacep/utils/latlong_cep.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMap();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }

  void _loadMap() async {
    Coordinate coordinate = await latlongCEP('19470000');
    setState(() {
      _mapController.move(
        LatLng(coordinate.lat, coordinate.lon),
        14,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 80,
        title: Image.asset(
          'assets/images/correios.png',
          height: 32,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 8,
              top: 12,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Transform.flip(
                flipX: true,
                child: Icon(
                  FluentIcons.list_16_filled,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 16,
            ),
            width: double.infinity,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardCount(
                  icon: FluentIcons.map_16_regular,
                  title: 'CEPs',
                  subtitle: 'SALVOS',
                  count: '15',
                ),
                SizedBox(width: 8),
                CardCount(
                  icon: FluentIcons.box_16_regular,
                  title: 'ENCOMENDAS',
                  subtitle: 'FEITAS',
                  count: '15',
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Text(
              'ÚLTIMAS BUSCAS',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(-23.55077425, -46.63386827),
                    initialZoom: 14,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.abnerjs.viacepapp',
                    ),
                    MarkerLayer(
                      markers: _markers,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cep_input');
        },
        tooltip: 'Enviar',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(
          FluentIcons.location_arrow_28_regular,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
