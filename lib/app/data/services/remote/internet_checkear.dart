import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class InternetCheckear {
  Future<bool> hasInternet() async {
    try {
      // kIsweb solo si esta corriendo en internet
      if (kIsWeb) {
        final response = await get(
          Uri.parse('8.8.8.8'),
        );
        return response.statusCode == 200;
      }
      final list = await InternetAddress.lookup('8.8.8.8');
      // si se cumple esta condicion entonces tenemos accesos a internet
      if (list.isNotEmpty && list.first.rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
