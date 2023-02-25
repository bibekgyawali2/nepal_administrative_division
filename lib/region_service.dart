// GET DISTRICT
import 'dart:convert';
import 'package:flutter/services.dart';
import 'modal.dart';

Future<AddressModal> getAddressFromJson() async {
  final String addressJson =
      await rootBundle.loadString('assets/json/address.json');
  var res = await jsonDecode(addressJson);
  AddressModal address = AddressModal.fromMap(res);
  return address;
}
