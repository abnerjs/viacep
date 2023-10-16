import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viacep/repository/via_cep_repository.dart';

class CEPListViewPage extends StatefulWidget {
  const CEPListViewPage({super.key});

  @override
  State<CEPListViewPage> createState() => _CEPListViewPageState();
}

class _CEPListViewPageState extends State<CEPListViewPage> {
  var cepRepository = ViaCepRepository();
  var ceps = [];
  var _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _loading = true;
    });
    var data = await cepRepository.getAllCEP();
    setState(() {
      ceps = data.results;
      _loading = false;
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ceps.length,
              itemBuilder: (context, index) => Slidable(
                key: ValueKey('$index'),
                endActionPane: ActionPane(
                  dismissible: DismissiblePane(onDismissed: () {}),
                  motion: const DrawerMotion(),
                  closeThreshold: 0.5,
                  dragDismissible: false,
                  children: [
                    SlidableAction(
                      autoClose: false,
                      onPressed: (context) {
                        try {
                          cepRepository.deleteCEP(ceps[index].objectId);
                          ceps.removeAt(index);
                          Slidable.of(context)?.dismiss(ResizeRequest(
                              const Duration(
                                milliseconds: 250,
                              ),
                              () {}));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('CEP removido'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Erro ao remover CEP'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );

                          debugPrint(e.toString());
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      icon: FluentIcons.delete_12_regular,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "${ceps[index].localidade} - ${ceps[index].uf}",
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF555555),
                    ),
                  ),
                  subtitle: ceps[index].logradouro != ""
                      ? Text(
                          "${ceps[index].logradouro} - ${ceps[index].bairro}",
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                        )
                      : null,
                  trailing: Text(
                    ceps[index].cep,
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
