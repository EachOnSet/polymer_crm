import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'crm_entities.dart';

@CustomTag('crm-contact')
class CRMContact extends PolymerElement {
  @observable int TotalContacts = 0;
  
  @observable List<Contact> listContacts = toObservable([]);
  
  CRMContact.created() : super.created();
  CRMContact polyElement = querySelector('#MainContacts');
    
  @override
  void enteredView() {
    super.enteredView();
    
    updateCount();
    
    fetchContacts();
  }
  
  // Fetch contacts
  void fetchContacts() {
    for (var key in window.localStorage.keys) {
      if (key.startsWith("CRM:")) {
        // Setup
        String strJSON = window.localStorage[key];
        Contact currentContact = new Contact.JSON(JSON.decode(strJSON));
        listContacts.add(currentContact);
      }
    }
    updateCount();
  }
  
  // Refresh contacts
  void refreshContacts() {
    if (!listContacts.isEmpty) {
      if (listContacts.length > 0) {
        listContacts.clear();
      }
    }

    for (var key in window.localStorage.keys) {
      if (key.startsWith("CRM:")) {
        // Setup
        String strJSON = window.localStorage[key];
        Contact currentContact = new Contact.JSON(JSON.decode(strJSON));
        listContacts.add(currentContact);
      }
    }
    updateCount();
  }
  
  // Function which removes a contact
  void removeContact(Event e, var detail, Element target) {
    String code = target.attributes['code'];
    
    // Call remove
    removeContactByEmail(code);
  }
  
  // Function which edits a contact
  void saveContact(Event e, var detail, Element target) {
    InputElement inputName = shadowRoot.querySelector("#name");
    InputElement inputEmail = shadowRoot.querySelector("#email");
    InputElement inputPhone = shadowRoot.querySelector("#phone");
    String code = target.attributes['code'];
    
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
    
    // Insert modifications
    Contact newContact = new Contact(inputName.value, inputEmail.value, inputPhone.value);
    try {
      //TODO bug suppression?
      //window.alert('OldEmail: '+ code);
      //window.alert('NewEmail: '+ inputEmail.value);
      if (code != inputEmail.value) {
        removeContactByEmail(code);
      }
      window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
      // Inform user
      displayConfirm('Contact edited');
      polyElement.refreshContacts();
      return;
    } on Exception catch(e) {
      displayErreur("Please enable LocalStorage.");
      return;
    } catch(e) {
      displayErreur(e.toString());
      return;
    }
  }
  
  // Function which removes a contact with email
  void removeContactByEmail(String inEmail) {    
    String key = "CRM:${inEmail}";
    if (!window.localStorage.containsKey(key)) {
      displayErreur("Unable to delete ${inEmail}");
      return;
    } else {
      try {
        String localKey = window.localStorage[key];
        window.localStorage.remove(key);
        // Inform user
        displayConfirm('Contact removed.');
        polyElement.refreshContacts();
        return ;
      } on Exception catch(e) {
        displayErreur("Please enable LocalStorage.");
        return ;
      } catch(e) {
        displayErreur(e.toString());
        return ;
      }
    }
  }
  
  // Total counter
  void updateCount() {
    int nbContacts = 0;
    
    for (var key in window.localStorage.keys) {
      if (key.startsWith("CRM:")) {
        nbContacts++;
      }
    }
    
    TotalContacts = nbContacts;
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
