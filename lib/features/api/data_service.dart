

import 'package:guardial/features/contacts/contacts_screen.dart';

import 'data_service_sqflite_impl.dart';

abstract class DataService{

  Future<List<Details>> getPersonDetails();
  Future<int> saveDetail(String name, String value);

  Future<int> insertContact(Contact contact);
  Future<int> updateContact(Contact contact);
  Future<List<Contact>> getContacts();
  Future<List<String>> getContactPhoneNumbers();
  Future<String> getStarredContact();
}
