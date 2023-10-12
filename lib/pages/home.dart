import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:viacep/components/card_count.dart';
import 'package:viacep/model/coordinate.dart';
import 'package:viacep/repository/via_cep_repository.dart';
import 'package:viacep/utils/latlong_cep.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  var cepRepository = ViaCepRepository();
  var ceps = [];

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
    _markers.clear();

    var data = await cepRepository.getAllCEP();
    setState(() {
      ceps = data.results;
    });
    for (var element in ceps) {
      _markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(
            double.parse(element.lat!),
            double.parse(element.lon!),
          ),
          child: IconButton(
            iconSize: 40,
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            icon: Icon(
              FluentIcons.location_24_filled,
              // ignore: use_build_context_synchronously
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    Coordinate coordinate = await latlongCEP(ceps[ceps.length - 1].cep!);
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
        scrolledUnderElevation: 0,
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
                  route: '/cep_list_view',
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
              top: 12,
            ),
            child: Row(
              children: [
                Text(
                  'ÚLTIMAS BUSCAS',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _loadMap();
                  },
                  iconSize: 16,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  icon: Icon(
                    FluentIcons.arrow_clockwise_12_filled,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                    opticalSize: 20,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 8,
                right: 8,
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
