import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import 'paginated_data_table_ext.dart';

class PaginatedGridSample extends StatefulWidget {
  const PaginatedGridSample({Key key}) : super(key: key);

  @override
  _PaginatedGridSampleState createState() => _PaginatedGridSampleState();
}

class _PaginatedGridSampleState extends State<PaginatedGridSample> {
  getSource() async {
    double v = 10;
    return [
      {'id': 1, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 2, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 3, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 4, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 5, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 6, 'dcto': '123', 'nome': 'nome', 'total': v++},
      for (var i = 0; i < 20; i++)
        {'id': i, 'dcto': '123', 'nome': 'nome', 'total': v++},
    ];
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatedGrid(
          header: Text('PaginatedGrid - Title'),
          futureSource: getSource(),
          currentPage: page,
          onPageSelected: (x) {
            setState(() {
              page = x;
            });
          },
          columns: [
            PaginatedGridColumn(
              name: 'id',
              label: '',
            ),
            PaginatedGridColumn(
              name: 'dcto',
              label: 'NFe',
            ),
            PaginatedGridColumn(
              name: 'nome',
            ),
            PaginatedGridColumn(
                name: 'total',
                label: 'Valor Bruto',
                numeric: true,
                onGetValue: (x) {
                  if (x is double) return x.toStringAsFixed(2);
                  return x;
                }),
          ]),
    );
  }
}

class PaginatedGridColumn {
  final String name;
  String label;
  String editInfo;
  TextStyle style;
  Alignment align;
  bool sort;
  bool required;
  bool readOnly;
  bool isPrimaryKey;
  final DataColumnSortCallback onSort;
  bool visible;
  final String Function(dynamic) onGetValue;
  final dynamic Function(dynamic) onSetValue;
  final String Function(dynamic) onValidate;
  final Widget Function(int, Map<String, dynamic>) builder;
  String tooltip;
  final Widget Function(PaginatedGridController, PaginatedGridColumn, dynamic,
      Map<String, dynamic>) editBuilder;

  final Function(PaginatedGridController) onEditIconPressed;
  bool autofocus;
  int maxLines;
  int maxLength;
  bool placeHolder;
  bool folded;
  PaginatedGridColumn({
    this.onEditIconPressed,
    this.numeric = false,
    this.autofocus = false,
    this.visible = true,
    this.maxLines,
    this.maxLength,
    this.tooltip,
    this.align,
    this.style,
    this.name,
    this.required = false,
    this.readOnly = false,
    this.isPrimaryKey = false,
    this.onSort,
    this.placeHolder = false,
    this.label,
    this.editInfo = '{label}',
    this.sort = true,
    this.builder,
    this.editBuilder,
    this.isVirtual = false,
    this.onGetValue,
    this.onSetValue,
    this.onValidate,
    this.folded,
  });
  bool numeric;
  bool isVirtual;
  int index;
}

enum PaginatedGridChangeEvent { insert, update, delete }

class PaginatedGrid extends StatefulWidget {
  final Future<dynamic> futureSource;
  final int Function(dynamic, dynamic) onSort;

  /// dados a serem apresentados
  final List<dynamic> source;

  /// colunas de apresentação dos dados
  final List<PaginatedGridColumn> columns;

  /// controle de navegação dos dados
  final PaginatedGridController controller;

  final Widget header;
  final double headerHeight;

  final List<Widget> actions;
  final int currentPage;

  /// [onPageSelected] evento de mudança de pagina para recarregar novos dados
  /// requer recarregar novos dados para a pagina solicitada
  final Function(int) onPageSelected;
  final Function(bool) onSelectAll;
  final int sortColumnIndex;
  final bool sortAscending;
  final TextStyle columnStyle;

  /// [beforeShow] evento beforeShow é chamado antes de apresentar os dados
  final Function(PaginatedGridController) beforeShow;
  final bool showCheckboxColumn;

  /// eventos de edição - permite criar novas janelas de edição para
  /// edição de dados -
  final bool Function(PaginatedGridController) onEditItem;
  final bool Function(PaginatedGridController) onNewItem;
  final Future<dynamic> Function(PaginatedGridController) onDeleteItem;

  final Function(PaginatedGridController) onRefresh;

  /// mudou a linha de edição
  final Function(bool, PaginatedGridController) onSelectChanged;

  ///[onChangeEvent] evento que os dados foram editados e podem ser persistidos
  final Future<dynamic> Function(
      PaginatedGridController, dynamic, PaginatedGridChangeEvent) onChangeEvent;

  /// indica se é para apresentar um barra de filtro dos dados de memoria
  final bool canFilter;

  /// [canChange] flag indicando que o registro pode ser alterado
  final bool canChange;
  final bool canDelete;
  final bool canInsert;

  final double columnSpacing;

  /// mudou a pagina de navegação em memoria
  final Function(int) onPageChanged;

  /// [rowsPerPage] numero de linhas por pagina
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final Function(int) onRowsPerPageChanged;
  final AppBar appBar;
  final Widget footerLeading;
  final Widget footerTrailling;

  final double dataRowHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final DragStartBehavior dragStartBehavior;

  /// [editSize] indica tamanho da janela de edição
  final Size editSize;

  /// envento onClick na celula
  final Function(PaginatedGridController) onCellTap;
  PaginatedGrid({
    Key key,
    this.controller,
    this.dataRowHeight = 56,
    this.headingRowHeight = 56,
    this.horizontalMargin = 10,
    this.dragStartBehavior = DragStartBehavior.start,
    this.futureSource,
    this.availableRowsPerPage,
    this.onRowsPerPageChanged,
    this.footerLeading,
    this.columns,
    this.editSize,
    this.footerTrailling,
    this.canChange = false,
    this.onPageChanged,
    this.rowsPerPage = 10,
    this.sortColumnIndex = 0,
    this.header,
    this.columnSpacing = 5,
    this.actions,
    this.onEditItem,
    this.onNewItem,
    this.onDeleteItem,
    this.canFilter = false,
    this.onSelectChanged,
    this.currentPage = 1,
    this.onPageSelected,
    this.onRefresh,
    this.onCellTap,
    this.onSelectAll,
    this.onChangeEvent,
    this.columnStyle,
    this.showCheckboxColumn = false,
    this.sortAscending = true,
    this.appBar,
    this.source,
    this.onSort,
    this.headerHeight = 64,
    this.beforeShow,
    this.canDelete = false,
    this.canInsert = false,
  }) : super(key: key);

  @override
  _PaginatedGridState createState() => _PaginatedGridState();

  static show(context,
      {String title, Widget child, Color color, List<Widget> actions}) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(8),
            title: AppBar(
              elevation: 0,
              title: Text(title ?? ''),
              actions: actions,
            ),
            backgroundColor: color,
            children: [child],
          );
        });
  }
}

class _PaginatedGridState extends State<PaginatedGrid> {
  PaginatedGridController controller;

  StreamController<bool> refreshEvent = StreamController<bool>.broadcast();

  int _sortColumnIndex;
  bool _sortAscending;

  String _filter;
  StreamSubscription postEvent;
  @override
  void initState() {
    controller = widget.controller ?? PaginatedGridController();
    controller.statePage = this;
    _filter = '';
    postEvent = controller.postEvent.stream.listen((x) {
      if (widget.onChangeEvent != null) {
        widget.onChangeEvent(controller, x.data, x.event).then((b) {
          if (b != null) {
            if (x.event == PaginatedGridChangeEvent.delete)
              controller.source.removeAt(controller.currentRow);
            else if (x.event == PaginatedGridChangeEvent.insert)
              controller.source.add(x.data);
            else
              controller.source[x.currentRow] = x.data;

//            if (controller.widget.onSort != null)
//              controller.source.sort((a, b) => controller.widget.onSort(a, b));

            controller.changed(true);
          }
        });
        return;
      }
      controller.source[x.currentRow] = x.data;
      controller.changed(true);
    });
    super.initState();
    _sortAscending = widget.sortAscending;
    _sortColumnIndex = widget.sortColumnIndex;
    controller.columns = widget.columns;
  }

  @override
  void dispose() {
    refreshEvent.close();
    postEvent.cancel();
    super.dispose();
  }

  createColumns(List<dynamic> source) {
    controller.columns = [];
    Map<String, dynamic> row = source.first;
    if (row != null)
      row.forEach((k, v) {
        controller.columns.add(PaginatedGridColumn(name: k, label: k));
      });
  }

  _sort(int idx, bool ascending) {
    setState(() {
      _sortColumnIndex = idx;
      _sortAscending = ascending;
      controller.source.sort((a, b) {
        return a[controller.columns[idx].name]
                .toString()
                .compareTo(b[controller.columns[idx].name].toString()) *
            (ascending ? 1 : -1);
      });
    });
  }

  addVirtualColumn() {
    int count = (widget.onEditItem == null) ? 0 : 1;
    controller.columns.forEach((col) {
      if (col.isVirtual) count = 0;
    });
    if (count > 0)
      controller.columns
          .add(PaginatedGridColumn(isVirtual: true, label: '', sort: false));

    for (var i = 0; i < controller.columns.length; i++) {
      controller.columns[i].index = i;
    }
  }

  doRefresh() {
    print('doRefresh');
    setState(() {
      widget.onRefresh(controller);
    });
  }

  ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    controller.context = context;
    return StreamBuilder<bool>(
        stream: refreshEvent.stream,
        builder: (context, snapshot) {
          return FutureBuilder(
              initialData: widget.source,
              future: widget.futureSource,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Align(child: CircularProgressIndicator());
                controller.widget = widget;
                controller.originalSource = snapshot.data;
                if (widget.onSort != null)
                  controller.originalSource.sort((a, b) {
                    return widget.onSort(a, b);
                  });
                //print('girdRows: ${controller.originalSource.length}');
                if ((controller.columns ?? []).length == 0)
                  createColumns(snapshot.data);
                addVirtualColumn();
                if (widget.beforeShow != null) widget.beforeShow(controller);
                return Scaffold(
                  appBar: widget.appBar,
                  floatingActionButton: buildAddButton(),
                  body: SingleChildScrollView(
                    child: StreamBuilder<bool>(
                        initialData: true,
                        stream: controller.changedEvent.stream,
                        builder: (context, snapshot) {
                          controller.tableSource =
                              PaginatedGridDataTableSource(controller, _filter);
                          return PaginatedDataTableExtended(
                            headingRowHeight: widget.headingRowHeight,
                            headerHeight: (widget.header == null)
                                ? 0
                                : widget.headerHeight,
                            dataRowHeight: widget.dataRowHeight,
                            columnSpacing: widget.columnSpacing,
                            footerTrailling: widget.footerTrailling,
                            footerLeading:
                                widget.footerLeading ?? createPageNavigator(),
                            header: ListView(children: [
                              widget.header ?? Container(),
                              if (widget.canFilter)
                                Container(
                                  padding: EdgeInsets.only(left: 8),
                                  height: 60,
                                  width: 200,
                                  child: TextFormField(
                                      initialValue: _filter,
                                      //controller: __filterController,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal),
                                      decoration: InputDecoration(
                                        //border: InputBorder.none,
                                        labelText: 'filtro',
                                      ),
                                      onChanged: (x) {
                                        _filter = x;
                                        controller.changedEvent.sink.add(true);
                                      }),
                                ),
                            ]),
                            actions: [
                              ...widget.actions ?? [],
                              if (widget.onRefresh != null)
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    doRefresh();
                                  },
                                ),
                            ],
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            horizontalMargin: widget.horizontalMargin,
                            dragStartBehavior: widget.dragStartBehavior,
                            onRowsPerPageChanged: widget.onRowsPerPageChanged,
                            rowsPerPage: widget.rowsPerPage,
                            onPageChanged: widget.onPageChanged,
                            columns: [
                              for (var i = 0;
                                  i < controller.columns.length;
                                  i++)
                                if (controller.columns[i].visible)
                                  DataColumn(
                                      onSort: controller.columns[i].onSort ??
                                              (controller.columns[i].sort)
                                          ? (int columnIndex, bool ascending) =>
                                              _sort(columnIndex, ascending)
                                          : (a, b) => null,
                                      numeric: controller.columns[i].numeric,
                                      tooltip: controller.columns[i].tooltip,
                                      label: Align(
                                        alignment:
                                            (controller.columns[i].numeric ??
                                                    false)
                                                ? Alignment.centerRight
                                                : controller.columns[i].align ??
                                                    Alignment.centerLeft,
                                        child: Text(
                                            controller.columns[i].label ??
                                                controller.columns[i].name,
                                            textAlign: TextAlign.center,
                                            style: widget.columnStyle ??
                                                TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                )),
                                      ))
                            ],
                            source: controller.tableSource,
                            onSelectAll: widget.onSelectAll,
                            showCheckboxColumn: widget.showCheckboxColumn,
                          );
                        }),
                  ),
                );
              });
        });
  }

  createPageNavigator() {
    if (widget.onPageSelected == null) return null;
    int n = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 60),
      child: Container(
        //constraints:
        //BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(children: [
            createNavButton(1),
            for (var i = widget.currentPage - 1;
                i < widget.currentPage + 4;
                i++)
              if (i > 1) if ((n++) < 4) createNavButton(i)
          ]),
        ),
      ),
    );
  }

  Widget createNavButton(int i) {
    return (widget.currentPage == i)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Text('$i'),
          )
        : IconButton(
            icon: Text('$i'),
            onPressed: () {
              widget.onPageSelected(i);
            },
          );
  }

  buildAddButton() {
    if (widget.canInsert &&
        ((widget.onNewItem != null) || (widget.onChangeEvent != null))) {
      return FloatingActionButton(
        //    child: IconButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.data = null;
          if (widget.onNewItem != null)
            controller.changed(widget.onNewItem(controller));
          else if (widget.onChangeEvent != null) {
            PaginatedGrid.show(context,
                title: 'Novo registro',
                child: PaginatedGridEditRow(
                  width: widget.editSize?.width,
                  height: widget.editSize?.height,
                  controller: controller,
                  event: PaginatedGridChangeEvent.insert,
                ));
          }
        },
        //),
      );
    } else
      return Container();
  }
}

class PaginatedGridController {
  BuildContext context;
  _PaginatedGridState statePage;
  StreamController<bool> changedEvent = StreamController<bool>.broadcast();
  List<dynamic> source;
  List<PaginatedGridColumn> columns;
  PaginatedGrid widget;
  PaginatedGridDataTableSource tableSource;
  int currentRow = 0;
  int currentColumn = 0;
  Map<String, dynamic> data;
  List<dynamic> originalSource;
  dispose() {
    changedEvent.close();
    postEvent.close();
  }

  PaginatedGridColumn findColumn(name) {
    var index = -1;
    for (int i = 0; i < columns.length; i++)
      if (columns[i].name == name) index = i;
    if (index > -1) return columns[index];
    return null;
  }

  clear() {
    originalSource.clear();
    source.clear();
    changed(true);
    _updating = 0;
  }

  int _updating = 0;
  begin([value = true]) {
    _updating += value ? 1 : -1;
  }

  end() {
    _updating--;
    changed(true);
  }

  changed([b = false]) {
    if (_updating <= 0) {
      if ((b ?? false)) changedEvent.sink.add(true);
      _updating = 0;
    }
  }

  changeTo(key, valueSearch, dadosTo) {
    begin();
    try {
      for (var i = 0; i < source.length; i++)
        if (source[i][key] == valueSearch) source[i] = dadosTo;
    } finally {
      end();
    }
  }

  StreamController<PaginatedGridEventData> postEvent =
      StreamController<PaginatedGridEventData>.broadcast();

  _changeRow(
      int row, Map<String, dynamic> data, PaginatedGridChangeEvent event) {
    postEvent.sink
        .add(PaginatedGridEventData(currentRow: row, event: event, data: data));
  }

  removeAt(int rowIndex) {
    source.removeAt(rowIndex);
    changed(true);
  }

  remove(item) {
    source.remove(item);
    changed(true);
  }
}

class PaginatedGridEventData {
  var event;
  var data;
  int currentRow;
  PaginatedGridEventData({this.currentRow, this.event, this.data});
}

class PaginatedGridDataTableSource extends DataTableSource {
  final PaginatedGridController controller;
  final String filter;
  PaginatedGridDataTableSource(this.controller, this.filter) {
    controller.source = [];
    if (filter != '')
      controller.originalSource.forEach((x) {
        var v = jsonEncode(x).toLowerCase();
        if (v.contains(filter.toLowerCase())) controller.source.add(x);
      });
    else {
      controller.source = controller.originalSource;
    }
  }
  setData(rowIndex, colIndex) {
    controller.currentRow = rowIndex;
    controller.currentColumn = colIndex;
    controller.data = controller.source[rowIndex];
  }

  @override
  DataRow getRow(int index) {
    Map<String, dynamic> row = controller.source[index];
    DataRow r = DataRow(
        key: UniqueKey(),
        onSelectChanged: (controller.widget.onSelectChanged != null)
            ? (bool b) {
                setData(index, 0);
                controller.widget.onSelectChanged(b, controller);
                return b;
              }
            : (controller.widget.canChange)
                ? (b) {
                    setData(index, 0);
                    return PaginatedGrid.show(
                      controller.context,
                      title: 'Alteração',
                      actions: [
                        if (controller.widget.canDelete)
                          if (controller.widget.onDeleteItem != null)
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                controller.widget
                                    .onDeleteItem(controller)
                                    .then((x) {
                                  if (x) {
                                    controller.removeAt(index);
                                    Timer.run(() {
                                      //print('pop');
                                      Navigator.pop(controller.context);
                                    });
                                    controller.changed(b);
                                  }
                                });
                              },
                            )
                      ],
                      child: PaginatedGridEditRow(
                        width: controller.widget.editSize?.width,
                        height: controller.widget.editSize?.height,
                        controller: controller,
                        event: PaginatedGridChangeEvent.update,
                      ),
                    );
                  }
                : null,
        cells: [
          for (PaginatedGridColumn col in controller.columns)
            if (col.visible)
              (col.isVirtual)
                  ? DataCell(Row(children: [
                      if (col.builder != null) col.builder(col.index, row),
                      if (col.builder == null)
                        if (controller.widget.canChange)
                          if (controller.widget.onEditItem != null)
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setData(index, col.index);
                                controller.changed(
                                    controller.widget.onEditItem(controller));
                              },
                            ),
                      if (col.builder == null)
                        if (controller.widget.canDelete)
                          if (controller.widget.onDeleteItem != null)
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setData(index, col.index);
                                controller.widget
                                    .onDeleteItem(controller)
                                    .then((x) {
                                  if (x) controller.removeAt(index);
                                });
                              },
                            )
                    ]))
                  : DataCell(
                      (col.builder != null)
                          ? col.builder(index, row)
                          : Align(
                              alignment: col.align ??
                                  ((col.numeric)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft),
                              child: Text(doGetValue(col, row[col.name]) ?? '',
                                  style: col.style),
                            ),
                      onTap: ((controller.widget.onCellTap != null) ||
                              (col.onEditIconPressed != null))
                          ? () {
                              setData(index, col.index);
                              if (controller.widget.onCellTap != null)
                                controller.widget.onCellTap(controller);
                              if (col.onEditIconPressed != null)
                                col.onEditIconPressed(controller);
                            }
                          : null,
                      showEditIcon: (col.onEditIconPressed != null),
                      placeholder: col.placeHolder,
                    ),
        ]);

    return r;
  }

  doGetValue(PaginatedGridColumn col, dynamic v) {
    if (col.onGetValue == null) return (v ?? '').toString();
    return col.onGetValue(v);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.source.length;

  @override
  int get selectedRowCount => 0;
}

class PaginatedGridEditRow extends StatefulWidget {
  final double width;
  final double height;
  final PaginatedGridController controller;
  final PaginatedGridChangeEvent event;
  const PaginatedGridEditRow(
      {Key key, this.event, this.controller, this.width, this.height})
      : super(key: key);

  @override
  _PaginatedGridEditRowState createState() => _PaginatedGridEditRowState();
}

class _PaginatedGridEditRowState extends State<PaginatedGridEditRow> {
  Map<String, dynamic> p;
  PaginatedGridChangeEvent _event;
  @override
  void initState() {
    _event = widget.event ??
        ((widget.controller.data == null)
            ? PaginatedGridChangeEvent.insert
            : PaginatedGridChangeEvent.update);
    p = widget.controller.data ?? {};
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool canEdit(PaginatedGridColumn col) {
    if (col.readOnly) return false;
    if (col.isPrimaryKey) {
      if (_event == PaginatedGridChangeEvent.update) return false;
    }
    return true;
  }

  bool _focused = false;
  bool canFocus(PaginatedGridColumn col) {
    if (_focused) return false;
    if (col.readOnly) return false;
    if (widget.event == PaginatedGridChangeEvent.update) if (col.isPrimaryKey)
      return false;
    _focused = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        //width: widget.width,
        //height: widget.height,
        constraints: BoxConstraints(
          minHeight: 300,
          minWidth: 200,
          maxHeight: widget.height ?? size.height * 0.9,
          maxWidth: widget.width ?? size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in widget.controller.columns)
                  if (!item.isVirtual)
                    (item.editBuilder != null)
                        ? item.editBuilder(
                            widget.controller, item, p[item.name], p)
                        : TextFormField(
                            autofocus: canFocus(item),
                            maxLines: item.maxLines,
                            maxLength: item.maxLength,
                            enabled: canEdit(item),
                            initialValue: (item.onGetValue != null)
                                ? item.onGetValue(p[item.name])
                                : (p[item.name] ?? '').toString(),
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.normal),
                            decoration: InputDecoration(
                              labelText: item.label ?? item.name,
                            ),
                            validator: (value) {
                              if (item.onValidate != null)
                                return item.onValidate(value);
                              if (item.required) if (value.isEmpty) {
                                return (item.editInfo.replaceAll(
                                    '{label}', item.label ?? item.name));
                              }

                              return null;
                            },
                            onSaved: (x) {
                              if (item.onSetValue != null) {
                                p[item.name] = item.onSetValue(x);
                                return;
                              }
                              if (p[item.name] is int)
                                p[item.name] = int.tryParse(x);
                              else if (p[item.name] is double)
                                p[item.name] = double.tryParse(x);
                              else if (p[item.name] is bool)
                                p[item.name] = x;
                              else
                                p[item.name] = x;
                            }),
                Divider(),
                FlatButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    _save(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _save(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.controller._changeRow(widget.controller.currentRow, p, _event);
      Navigator.pop(context);
    }
  }
}
