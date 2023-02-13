import 'package:guardial/core/sqflite_database_util.dart';
import 'package:guardial/features/contacts/contacts_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'data_service.dart';

class DataServiceImpl extends DataService {
  var personDetailsTable = 'person_details';
  var contactsTable = 'contacts';

  @override
  Future<List<Details>> getPersonDetails() async {
    //print('inside service getPersonDetails ');
    final Database db = await DatabaseHandler.initializeDB();

    final List<Map<String, Object?>> queryResult =
        await db.query(personDetailsTable);
    return queryResult.map((e) => Details.fromMap(e)).toList();
  }

  @override
  Future<int> saveDetail(String name, String value) async {
    print('DataServiceImpl: saveDetail: saving detail $name and $value');
    final Database db = await DatabaseHandler.initializeDB();
    Map<String, String> map = Details.toMap(name, value);
    print('DataServiceImpl: saveDetail: map $map');
    return await db.insert(personDetailsTable, map);
  }

  @override
  Future<int> insertContact(Contact contact) async {
    print('DataServiceImpl: saveContact: saving contact $contact');
    final Database db = await DatabaseHandler.initializeDB();
    var map = contact.toMap();
    print('DataServiceImpl: saveCar: car.toMap() $map');
    return await db.insert(contactsTable, map);
  }

  @override
  Future<int> updateContact(Contact contact) async {
    print('DataServiceImpl: saveContact: saving contact $contact');
    final Database db = await DatabaseHandler.initializeDB();
    var map = contact.toMap();
    print('DataServiceImpl: saveCar: car.toMap() $map');
    return await db
        .update(contactsTable, map, where: "id=?", whereArgs: [contact.id]);
  }

  @override
  Future<List<Contact>> getContacts() async {
    final Database db = await DatabaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(contactsTable);
    print('contacts length $queryResult');
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  Future<List<String>> getContactPhoneNumbers() async {
    DataService dataService = DataServiceImpl();
    final List<Contact> contacts = await dataService.getContacts();
    List<String> phoneNumbers = contacts
        .where((element) => element.phoneNumber.length == 10)
        .map((e) => e.phoneNumber)
        .toList();
    return phoneNumbers;
  }

  Future<String> getStarredContact() async {
    DataService dataService = DataServiceImpl();
    final List<Contact> contacts = await dataService.getContacts();
    List<Contact> starredContacts = contacts
        .where((element) => element.phoneNumber.length == 10 && element.isFav)
        .toList();

    return starredContacts.isEmpty
        ? contacts
            .firstWhere((element) => element.phoneNumber.length == 10)
            .phoneNumber
        : starredContacts.first.phoneNumber;
  }
}

class Details {
  String key;
  String value;

  Details(this.key, this.value);

  Details.fromMap(Map<String, dynamic> res)
      : key = res["key"],
        value = res["value"];

  static Map<String, String> toMap(String name, String value) {
    Map<String, String> map = Map();
    map.putIfAbsent("key", () => name);
    map.putIfAbsent("value", () => value);
    return map;
  }
}
