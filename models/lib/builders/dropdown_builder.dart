import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/masked_field.dart';
import 'package:flutter/material.dart';

class DropdownDataBuilder extends StatelessWidget {
  final String? collection;
  final String? fields;
  final String? keyField;
  final String? nameField;
  final Widget Function(BuildContext, List<dynamic>)? builder;
  const DropdownDataBuilder(
      {Key? key,
      @required this.builder,
      this.collection,
      this.fields = 'codigo,nome',
      this.keyField = 'codigo',
      this.nameField = 'nome'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ODataBuilder(
      query: ODataQuery(
        resource: collection,
        select: fields,
      ),
      cacheControl: 'max-age=360',
      builder: (ctx, snap) {
        if (snap.hasData) {
          List<dynamic> items = snap.data.asMap();
          items.sort((a, b) => (a[nameField] ?? '')
              .toString()
              .toUpperCase()
              .compareTo((b[nameField] ?? '').toString().toUpperCase()));
          items.insert(0, {'$keyField': '0', '$nameField': ''});
          return builder!(ctx, items);
        }
        return Container();
      },
    );
  }

  static createDropDownFormField(BuildContext context,
      {value,
      @required String? label,
      @required String? collection,
      String fields = 'codigo,nome',
      Function(String)? onChanged,
      String keyField = 'codigo',
      String nameField = 'nome'}) {
    return DropdownDataBuilder(
        collection: collection!,
        fields: fields,
        keyField: keyField,
        nameField: nameField,
        builder: (ctx, List<dynamic> items) {
          var corrente = items
              .firstWhere((item) => (item[keyField] ?? '0') == (value ?? '0'));
          List<String> keys = [];
          items.forEach((item) {
            if (keys.indexOf(item[nameField]) < 0) keys.add(item[nameField]);
          });
          return createDropDownFormFieldContainer(
              padding: EdgeInsets.all(0),
              hintText: label ?? '',
              items: keys,
              onChanged: (newValue) {
                var item = items.firstWhere((it) => it[nameField] == newValue);
                if (item != null) {
                  var codigo = '${item[keyField]}';
                  onChanged!(codigo);
                }
              },
              value: corrente[nameField] ?? '');
        });
  }
}

Widget createDropDownFormFieldContainer(
    {List<String>? items,
    String? hintText,
    TextStyle? style,
    String? value,
    Function? onChanged,
    Function? onSaved,
    Function? validator,
    String? errorMsg,
    Color? hintColor,
    EdgeInsetsGeometry? padding}) {
  return MaskedDropDownFormField(
    items: items,
    hintText: hintText,
    style: style,
    value: value,
    onChanged: onChanged,
    onSaved: onSaved,
    validator: validator,
    errorMsg: errorMsg,
    hintColor: hintColor,
    padding: padding,
  );
}
