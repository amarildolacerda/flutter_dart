import 'dart:convert';
import 'dart:typed_data';

//import 'package:controls_data/cached.dart';
import 'package:controls_data/cached.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';

class ProdutoMetadata {
  String? gtin;
  String? unit;
  String? description;
  String? tag;
  String? origem;
  toJson() {
    return {
      "gtin": gtin,
      "unit": unit,
      "description": description,
      "tag": tag,
      "origem": origem
    };
  }
}

class StorageApi {
  bool inited = false;
  CacheManager? instance;
  init() {
    if (inited) return;
    instance = CacheManager(Config(
      'firestorage_image_cache_manager',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ));
  }

  //Future<Uint8List>
  download(String path, {bool cached = true}) async {
    init();
    if (path.startsWith('http'))
      return instance!.getSingleFile(path).then((f) => f.readAsBytes());
    if (path.startsWith('assets'))
      return rootBundle.load(path).then((f) => f.buffer.asUint8List());

    var _img = 'image_$path';
    var client = CloudV3().client.clone();
    client.prefix = '';
    var url = client.client.formatUrl(path: '/storage/download64?path=' + path);
    var cache = () => client.client
            .rawData(
          url,
          contentType: 'text/plain',
          method: 'GET',
          cacheControl: (cached) ? 'public; max-age:3600' : null,
        )
            .then((rsp) {
          var img64 = rsp.data.split('base64,').last;
          Uint8List decoded = base64Decode(img64);

          if (UniversalPlatform.isWeb) {
            Cached.add('image_$path', decoded);
          } else {
            instance!.putFile(_img, decoded);
          }
          return decoded;
        }).catchError((err) {
          return null;
        });
    if (!cached) return cache();
    if (UniversalPlatform.isWeb)
      return Cached.value('image_$path', builder: (k) => cache());
    var file = await instance!.getFileFromCache(_img);
    if (file != null) return await file.file.readAsBytes();
    return cache();
  }

  clear() {
    init();
    instance!.emptyCache();
  }

  upload(Uint8List file, String path, {Map<String, dynamic>? metadata}) async {
    // carregar o arquivo
    final Uint8List bytes = file;
    final ext = path.split('.').last; // ?? 'jpg';
    // gerar base64
    String img64 = base64Encode(bytes);
    var data = {
      "path": path,
      "metadata": (metadata ?? {})..["sender"] = "Storeware Console",
      "content": 'data:image/$ext;base64,' + img64,
      "contentType": 'image/jpeg'
    };

    // enviar para o servidor
    var client = CloudV3().client.clone();
    client.prefix = '';
    var url = client.client.formatUrl(path: '/storage/upload64?path=' + path);
    return client.client
        .rawData(url,
            method: 'POST',
            body: data,
            contentType: 'application/json',
            cacheControl: 'public; max-age=3600')
        .then((rsp) {
      //imageCache.
      clear();
      return rsp.data;
    });
  }
}
