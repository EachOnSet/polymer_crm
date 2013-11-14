library crm_entities;

import 'dart:convert';
import 'package:polymer/polymer.dart';

// A contact itself
class Contact {
  @observable String name;
  @observable String email;
  @observable String phone;
  
  Contact(name, email, phone) {
    this.name = name;
    this.email = email;
    this.phone = phone;
  }
  
  Contact.JSON(Map inJSONMap) {
    this.name = inJSONMap["name"];
    this.email = inJSONMap["email"];
    this.phone = inJSONMap["phone"];
  }

  String toJSON() {
    var MapContact = new Map<String, Object>();
    MapContact["name"] = name;
    MapContact["email"] = email;
    MapContact["phone"] = phone;
    return JSON.encode(MapContact);
  }

  void fromJSON(Map JSONString) {
    this.name = JSONString["name"];
    this.phone = JSONString["phone"];
    this.email = JSONString["email"];
  }
}
