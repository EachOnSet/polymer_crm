import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
export 'package:polymer/init.dart';
import 'crm_entities.dart';

// Override polymer start
main() {
  initPolymer();
  
  registerListeners();
  var id = "CRM";
  if (!window.localStorage.containsKey(id)) {
    fillWithFakeNames();
  }
}

// Function which registers all the button listeners
void registerListeners(){
  querySelector('#view-button').onClick.listen((e){
    toggleView(1);
  });
  
  querySelector('#add-button').onClick.listen((e){
    toggleView(2);
  });
}

// Switch between the two tables
void toggleView(int inMode){
  // List
  if (inMode == 1) {
    querySelector('#contacts').classes.toggle('hidden');
    querySelector('#add-contacts').classes.toggle('hidden');
  // Add
  } else if (inMode == 2) {
    querySelector('#contacts').classes.toggle('hidden');
    querySelector('#add-contacts').classes.toggle('hidden');
  }
}

// Error helper
void displayErreur(String inMessage){
  querySelector('#error').innerHtml = inMessage;
  querySelector('#confirm').innerHtml = '';
}

// Confirm helper
void displayConfirm(String inMessage){
  querySelector('#confirm').innerHtml = inMessage;
  querySelector('#error').innerHtml = '';
}

// Fill CRM with dumb names
void fillWithFakeNames(){
  Contact newContact = new Contact("John Smith", "john@smith.com", "555-111-2222");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
  newContact = new Contact("Stephen Harper", "wannabe@gov.com", "555-222-5556");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
  newContact = new Contact("Barack Obama", "godbless@america.com", "555-333-8888");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
}
