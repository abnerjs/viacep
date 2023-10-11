import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CEPListViewPage extends StatefulWidget {
  const CEPListViewPage({super.key});

  @override
  State<CEPListViewPage> createState() => _CEPListViewPageState();
}

class _CEPListViewPageState extends State<CEPListViewPage> {
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
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) => Slidable(
          key: ValueKey('$index'),
          endActionPane: ActionPane(
            dismissible: DismissiblePane(onDismissed: () {}),
            motion: const DrawerMotion(),
            closeThreshold: 0.5,
            dragDismissible: false,
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                icon: FluentIcons.edit_12_regular,
              ),
              SlidableAction(
                autoClose: false,
                onPressed: (context) {
                  Slidable.of(context)?.dismiss(ResizeRequest(
                      const Duration(
                        milliseconds: 250,
                      ),
                      () {}));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('CEP removido!'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      action: SnackBarAction(
                        label: 'Desfazer',
                        textColor: Theme.of(context).colorScheme.onError,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                icon: FluentIcons.delete_12_regular,
              ),
            ],
          ),
          child: ListTile(
            title: Text('Rua $index'),
            subtitle: Text('Bairro $index'),
            trailing: Text('CEP $index'),
          ),
        ),
      ),
    );
  }
}
