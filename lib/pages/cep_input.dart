// ignore_for_file: use_build_context_synchronously

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinput/pinput.dart';
import 'package:viacep/model/coordinate.dart';
import 'package:viacep/model/via_cep.dart';
import 'package:viacep/repository/via_cep_repository.dart';
import 'package:viacep/utils/latlong_cep.dart';

class CEPInputPage extends StatefulWidget {
  const CEPInputPage({super.key});

  @override
  State<CEPInputPage> createState() => _CEPInputPageState();
}

class _CEPInputPageState extends State<CEPInputPage> {
  ViaCepRepository viaCepRepository = ViaCepRepository();
  var cepController = TextEditingController();
  ViaCep viaCep = ViaCep();
  Coordinate coordinate = Coordinate(-23.55077425, -46.63386827);
  final MapController _mapController = MapController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/images/correios.png',
          height: 32,
        ),
        automaticallyImplyLeading: false,
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
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
              bottom: 8,
            ),
            child: Text(
              'DIGITE O CEP',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Pinput(
              defaultPinTheme: PinTheme(
                width: 56,
                height: 40,
                textStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                decoration: const BoxDecoration(),
              ),
              length: 8,
              pinAnimationType: PinAnimationType.slide,
              showCursor: true,
              controller: cepController,
              cursor: cursor,
              preFilledWidget: preFilledWidget,
              autofocus: true,
              onChanged: (value) {
                if (value.length < 8) {
                  viaCep = ViaCep();
                  coordinate = Coordinate(-23.55077425, -46.63386827);
                  _mapController.move(
                    LatLng(coordinate.lat, coordinate.lon),
                    14,
                  );
                  setState(() {});
                }
              },
              onCompleted: (pin) async {
                setState(() {
                  _isLoading = true;
                });
                viaCep = await viaCepRepository.getCEP(pin);
                if (viaCep.cep != null) {
                  coordinate = await latlongCEP(pin);
                  setState(() {
                    _isLoading = false;
                  });
                  _mapController.move(
                    LatLng(coordinate.lat, coordinate.lon),
                    14,
                  );
                  setState(() {});
                } else {
                  setState(() {
                    _isLoading = false;
                  });

                  viaCep = ViaCep();
                  coordinate = Coordinate(-23.55077425, -46.63386827);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(
                        'CEP não encontrado!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      showCloseIcon: true,
                    ),
                  );
                  _mapController.move(
                    LatLng(coordinate.lat, coordinate.lon),
                    14,
                  );
                }
              },
            ),
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
          _buildCEPInfo(context, viaCep),
          _buildMap(context, viaCep, coordinate, _mapController),
          viaCep.cep != null || _isLoading ? Container() : const Spacer(),
          Container(
            margin: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                viaCep.cep == null
                    ? Container()
                    : const SizedBox(
                        width: 8,
                      ),
                viaCep.cep == null
                    ? Container()
                    : Expanded(
                        child: TextButton(
                          onPressed: () async {
                            try {
                              await viaCepRepository.createCEP(
                                ViaCep.create(
                                  viaCep.cep,
                                  viaCep.localidade,
                                  viaCep.uf,
                                  viaCep.logradouro,
                                  viaCep.bairro,
                                  coordinate.lat.toString(),
                                  coordinate.lon.toString(),
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  content: const Text(
                                    'CEP salvo!',
                                  ),
                                  showCloseIcon: true,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  content: const Text(
                                    'Erro ao salvar CEP',
                                  ),
                                  showCloseIcon: true,
                                ),
                              );
                            } finally {
                              Navigator.pop(context, true);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(
                            "Salvar",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_buildMap(BuildContext context, ViaCep viaCep, Coordinate coordinate,
    MapController mapController) {
  if (viaCep.cep != null) {
    return Expanded(
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
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(coordinate.lat, coordinate.lon),
              initialZoom: 14,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.abnerjs.viacepapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(coordinate.lat, coordinate.lon),
                    child: Icon(
                      FluentIcons.location_24_filled,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  return Container();
}

_buildCEPInfo(BuildContext context, ViaCep viaCep) {
  if (viaCep.cep != null) {
    List<Widget> cepInfo = [];

    if (viaCep.logradouro != null && viaCep.logradouro!.isNotEmpty) {
      cepInfo.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LOGRADOURO',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              viaCep.logradouro!,
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    if (viaCep.bairro != null && viaCep.bairro!.isNotEmpty) {
      cepInfo.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BAIRRO',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              viaCep.bairro!,
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    if (viaCep.localidade != null && viaCep.localidade!.isNotEmpty) {
      cepInfo.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LOCALIDADE',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              viaCep.localidade!,
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }
    if (viaCep.uf != null && viaCep.uf!.isNotEmpty) {
      cepInfo.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ESTADO',
              style: GoogleFonts.robotoCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              viaCep.uf!,
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...cepInfo,
        ],
      ),
    );
  }
  return Container();
}
