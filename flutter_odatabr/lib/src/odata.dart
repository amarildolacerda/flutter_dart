/*
  Auth: amarildo lacerda <amarildo_51@msn.com.br>
  Revs:
    12/2018 - new
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ODataKey {
  String name;
  String value;
}

class ODataDocuments {
  List<dynamic> data = [];
  int count;
  List<dynamic> keys = [];
  Map<String, dynamic> properties = {};
  DateTime startsAt;
  DateTime endsAt;
}

class ODataBloc<T> {
  final _controller = StreamController<T>();
  Stream<T> get stream => _controller.stream;
  Sink<T> get sink => _controller.sink;

  void dispose() {
    _controller.close();
  }
}

class OData extends _ODataBuilder {
  final String host;
  Map<String, String> maps = {
    "count": "@odata.count",
    "startsAt": "StartsAt",
    "endsAt": "EndsAt",
    "value": "value",
    "keys": "keys",
    "properties": "properties"
  };
  bool canReload = false;
  List<ODataKey> _header = [];
  String contentType = "application/json";
  ODataDocuments docs = ODataDocuments();
  ODataBloc<ODataDocuments> queryBloc = ODataBloc<ODataDocuments>();

  OData(this.host,
      {String collection,
      String filter,
      String group,
      String select,
      String order,
      int skip = 0,
      int top = 0,
      String doc}) {
    super.collection(collection);
    super.filter(filter);
    super.group(group);
    super.doc(doc);
    super.skip = skip;
    super.top = top;
    super.select(select);
    super.order(order);
  }

  static Map<String, dynamic> encode(Map<String, dynamic> values) {
    Map<String, dynamic> m = {};
    values.forEach((k, v) {
      if (v is DateTime)
        m[k] = v.toIso8601String();
      else
        m[k] = v;
    });
    return m;
  }

  static String asJson(dynamic object) {
    const jsonCodec = JsonCodec();
    return jsonCodec.encode(object, toEncodable: (o) {
      if (o is DateTime) return o.toIso8601String();
    });
  }

  static dynamic fromJson(String json) {
    const jsonCodec = JsonCodec();
    return jsonCodec.decode(json, reviver: (k, v) {
      if (v is String && v.length > 13) if (v.substring(10, 11) == 'T' &&
          v.substring(13, 14) == ':') {
        DateTime d = DateTime.tryParse(v.substring(0, 23));
        if (d != null)
          return d;
        else
          return v;
      }
      return v;
    });
  }

  @override
  Stream<ODataDocuments> get() {
    canReload = true;
    reload();
    return queryBloc.stream;
  }

  reload() {
    String url = getUri('');
    _get(url, true).then((json) {
      dynamic response = OData.fromJson(json);
      docs.data = response[maps['value']];
      int length = docs.data.length;
      docs.count = response[maps['count']] ?? length;
      docs.keys = response[maps['keys']] ?? [];
      docs.properties = response[maps['properties']] ?? {};
      docs.startsAt = response[maps['startsAt']];
      docs.endsAt = response[maps['endsAt']];
      print(docs.endsAt);
      queryBloc.sink.add(docs);
    });
  }

  _setHeader(HttpClientRequest request) {
    _header.forEach((k) {
      request.headers.set(k.name, k.value);
    });
    request.headers.add(HttpHeaders.contentTypeHeader, contentType);
  }

  Future<String> _get(String url, [bool encodeUtf8 = true]) async {
    return await openUrl('GET', url);
    /* HttpClient httpClient = new HttpClient();
    Uri urlFinal = Uri.parse(host + url);
    print(urlFinal);
    HttpClientRequest request =
        await httpClient.getUrl(urlFinal).catchError((err) {
      print(err);
    });
    _setHeader(request);

    HttpClientResponse response = await request.close();
    var statusCode = response.statusCode;
    if (response.statusCode == 200) {
      if (!encodeUtf8) return response.toString();
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    } else {
      print('response.statusCode: $statusCode');
      String reply = await response.transform(utf8.decoder).join();
      return throw (reply);
    }
    */
  }

  Future<String> post(String servico, [jsonObj]) async {
    return await openUrl('POST', servico, jsonObj);
  }

  Future<String> put(String servico, [dynamic jsonObj]) async {
    return await openUrl('PUT', servico, jsonObj);
  }

  Future<String> delete(String servico, [dynamic jsonObj]) async {
    return await openUrl('DELETE', servico, jsonObj);
  }

  Future<String> patch(String servico, [dynamic jsonObj]) async {
    return await openUrl('PATCH', servico, jsonObj);
  }

  Future<String> options(String servico, [dynamic jsonObj]) async {
    return await openUrl('OPTIONS', servico, jsonObj);
  }

  Future<String> openUrl(String method, String servico,
      [dynamic jsonObj]) async {
    Uri url = Uri.parse(host + servico);
    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.openUrl(method, url);
    _setHeader(request);
    if (jsonObj != null) {
      String js;
      if (jsonObj is String)
        js = jsonObj;
      else
        js = asJson(jsonObj);
      request.write(js);
    }
    HttpClientResponse response = await request.close();
    var statusCode = response.statusCode;
    if (response.statusCode == 200) {
      // done - you should check the response.statusCode
      String reply = await utf8.decoder.bind(response).join();
      //print(reply);
      return reply;
    } else {
      print('response.statusCode: $statusCode');
      String reply = await utf8.decoder.bind(response).join();
      //print(reply);
      return throw (reply);
    }
  }
}

class _ODataBuilder {
  String _collection;
  String _select;
  String _filter;
  String service = '/OData.svc';
  String servicePrefix = '/OData';
  bool count = false;
  dynamic _doc;
  String _order;
  int skip = 0;
  int top = 0;
  String _group;

  _ODataBuilder collection(String cName) {
    _collection = cName;
    return this;
  }

  _ODataBuilder take(int count) {
    top = count;
    return this;
  }

  _ODataBuilder doc(dynamic docId) {
    _doc = docId;
    return this;
  }

  _ODataBuilder select(cListColums) {
    _select = cListColums;
    return this;
  }

  _ODataBuilder group(cGroup) {
    _group = cGroup;
    return this;
  }

  _ODataBuilder order(cColumn) {
    _order = cColumn;
    return this;
  }

  _ODataBuilder filter(cFilter) {
    _filter = cFilter;
    return this;
  }

  String getUri(String cHost) {
    String cmd = cHost + servicePrefix + service;
    String query = '';
    cmd += '/$_collection';
    if (_doc != null) {
      if (_doc is int)
        cmd += "($_doc)";
      else if (_doc is double)
        cmd += "($_doc)";
      else
        cmd += "('$_doc')";
    }
    if (_filter != null) {
      query += '\$filter=$_filter&';
    }
    if (_select != null) {
      query += '\$select=$_select&';
    }
    if (count) query += '\$count=true';
    if (_order != null) query += '\$order=$_order';
    if (skip > 0) query += '\$skip=$skip';
    if (top > 0) query += '\$top=$top';
    if (_group != null) query += '$group=$_group';

    if (query != '') {
      cmd += '?$query';
    }

    return cmd;
  }

  Stream<ODataDocuments> get() {
    return null;
  }
}
