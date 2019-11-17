import 'package:app/views/drawer_view.dart';
import 'package:controls_web/controls/sliver_scaffold.dart';

import '../models/constantes.dart';
import 'package:flutter/material.dart';

class EntradaView extends StatefulWidget {
  EntradaView({Key key}) : super(key: key);
  @override
  _EntradaViewState createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      drawer: Drawer(child: DrawerView()),
      appBar: AppBar(
        title: Text(Constantes.appNome),
      ),
      body: Text('entrada view'),
    );
  }
}
