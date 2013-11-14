import 'dart:html';
import 'package:polymer/polymer.dart';
import 'crm_contact.dart';
import 'crm_entities.dart';

@CustomTag('crm-add')
class AddContact extends PolymerElement {
  AddContact.created() : super.created();
  
  ButtonElement addButton;
  InputElement inputName;
  InputElement inputEmail;
  InputElement inputPhone;
  
  CRMContact polyElement = querySelector('#MainContacts');
  
  @override
  void enteredView() {
    super.enteredView();
    addButton = $['addButton'];
    inputName = $['name'];
    inputEmail = $['email'];
    inputPhone = $['phone'];
  }
  
  void addContact(Event e, var detail, Node target) {
    
    // Validate name
    if (inputName.value == null || inputName.value.isEmpty) {
      displayErreur("Cannot set empty name.");
      return;
    }
    
    // Validate email
    var exp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (inputEmail.value == null || inputEmail.value.isEmpty) {
      displayErreur("Cannot set empty email.");
      return;
    } else if (!exp.hasMatch(inputEmail.value)) {
      displayErreur("Email format not valid.");
      return;
    }
    
    // Validate phone
    exp = new RegExp(r"[0-9]{3}-[0-9]{3}-[0-9]{4}");
    if (inputPhone.value == null || inputPhone.value.isEmpty) {
      displayErreur("Cannot set empty phone.");
      return;
    } else if (!exp.hasMatch(inputPhone.value)) {
      displayErreur("Phone format not valid (XXX-XXX-XXXX).");
      return;
    }
    
    Contact newContact = new Contact(inputName.value, inputEmail.value, inputPhone.value);
    try {
      window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
      displayConfirm('Contact added');
      polyElement.refreshContacts();
      inputName.value = "";
      inputEmail.value = "";
      inputPhone.value = "";
      return;
    } on Exception catch(e) {
      displayErreur("Please enable LocalStorage.");
      return;
    } catch(e) {
      displayErreur(e.toString());
      return;
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
  
}
