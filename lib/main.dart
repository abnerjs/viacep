import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:viacep/components/card_count.dart';
import 'package:viacep/model/coordinate.dart';
import 'package:viacep/utils/latlong_cep.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF023f6c),
          primary: const Color(0xFF023f6c),
          onPrimary: Colors.white,
          background: Colors.white,
          secondary: const Color(0xFFfedc01),
          onSecondary: const Color(0xFF023f6c),
          tertiary: const Color(0xFFa9bdcd),
          onTertiary: const Color(0xFF023f6c),
          primaryContainer: const Color(0xFFf0f3f6),
          onPrimaryContainer: const Color(0xFF023f6c),
        ),
        splashColor: const Color(0x80FFFFFF),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Correios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    Coordinate coordinate = await latlongCEP('08770020');
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
              top: 8,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      'Olá,',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      " Abner",
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                bottom: 8,
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
        onPressed: () {},
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
