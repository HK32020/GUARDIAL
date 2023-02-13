import 'package:flutter/material.dart';
import 'package:guardial/core/WidgetUtils.dart';
import 'package:guardial/features/api/data_service.dart';
import 'package:guardial/features/api/data_service_sqflite_impl.dart';
import 'package:guardial/utils/utils.dart';

class Contact {
  Contact(this.id, this.name, this.phoneNumber, this.isFav);

  int id;
  String name;
  String phoneNumber;
  bool isFav;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phoneNumber,
      'is_default': isFav ? 1 : 0
    };
  }

  Contact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        phoneNumber = res["phone"].toString(),
        isFav = res["is_default"] == 1 ? true : false;
}

class ContactsScreen extends StatefulWidget {
  ContactsScreen(this.skipNeeded, {Key? key}) : super(key: key);
  final bool skipNeeded;

  @override
  _ContactsScreenState createState() => _ContactsScreenState();

  final GlobalKey<AnimatedListState> _contactsListKey =
      GlobalKey<AnimatedListState>();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DataService service = DataServiceImpl();
  List<Contact> contacts = [];
  bool showContinueButton = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: APP_BACKGROUND_GREY_COLOR,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MAIN_BLUE_COLOR, //change your color here
        ),
        backgroundColor: Palette.guardialPurple,
        title: Text("CONTACTS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            if (widget.skipNeeded)
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () => WidgetUtils.navigateToHomeScreen(context),
                  child: Text('Skip'),
                ),
              ),
            Center(
                child: Text('Star your best contact to call',
                    style: TextStyle(color: BLACK_TEXT_COLOR))),
            FutureBuilder<List<Contact>>(
              future: service.getContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null || snapshot.data!.length == 0) {
                    contacts = [
                      Contact(1, "", "", false),
                      Contact(2, "", "", false),
                      Contact(3, "", "", false),
                      Contact(4, "", "", false),
                      Contact(5, "", "", false),
                      Contact(6, "", "", false)
                    ];
                    contacts.forEach((element) {
                      service.insertContact(element);
                    });
                  } else {
                    contacts = snapshot.data!;
                  }

                  return AnimatedList(
                    key: widget._contactsListKey,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    //itemCount: snapshot.data,
                    initialItemCount: contacts.length,
                    /*itemBuilder: (context, index) {
                    return buildContactWidget(context, index, contacts);
                  },*/
                    itemBuilder: (context, index, animation) {
                      contacts[index].id = index + 1;
                      return EditableListTile(
                        index: index,
                        contact: contacts[index],
                        onChanged: (Contact updatedModel) {
                          /// Gets called when the save Icon is tapped on the List Tile.
                          //contacts[index]; // = updatedModel;
                          service.updateContact(updatedModel);
                        },
                        saveFav: (Contact updatedModel) {
                          /// Gets called when the fav Icon is tapped on the List Tile.
                          setState(() {
                            contacts.forEach((element) {
                              element.isFav = false;
                              service.updateContact(element);
                            });
                          });
                          contacts[index].isFav = true;
                          service.updateContact(contacts[index]);
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            /*if (widget.skipNeeded)
              ElevatedButton(
                onPressed: () {
                  if (contacts.any(
                          (element) => element.phoneNumber.length == 10)) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text('Error !!'),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text(
                                      'Please add one valid contact to continue.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    WidgetUtils.navigateToHomeScreen(context);
                  }
                },
                child: Text('Continue'),
              )*/
          ]),
        ),
      ),
    ));
  }
}

class EditableListTile extends StatefulWidget {
  final int index;
  final Contact contact;
  final Function(Contact listModel) onChanged;
  final Function(Contact listModel) saveFav;

  EditableListTile(
      {required this.index,
      required this.contact,
      required this.onChanged,
      required this.saveFav})
      : super();

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool _isEditingMode = false;

  late TextEditingController _nameEditingController,
      _phoneNumberEditingController;

  @override
  void initState() {
    super.initState();
    _nameEditingController = TextEditingController();
    _phoneNumberEditingController = TextEditingController();
    this._isEditingMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleWidget,
      //subtitle: subTitleWidget,
      //trailing: trailingButton,
    );
  }

  Widget get titleWidget {
    _nameEditingController = TextEditingController(text: widget.contact.name);
    _phoneNumberEditingController =
        TextEditingController(text: widget.contact.phoneNumber);
    return /*TextField(
        controller: _nameEditingController,
      );*/
        buildContactWidget(context, widget.index);
  }

  Widget buildContactWidget(BuildContext context, int index) {
    return Card(
        //shadowColor: orangeColor,
        key: Key('contact ${widget.contact.id}'),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
          //side: BorderSide(width: 1, color: orangeColor)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: Row(
                children: [
                  Text(
                    'Contact ${widget.contact.id}',
                    style: TextStyle(color: MAIN_BLUE_COLOR, fontSize: 25),
                  ),
                  Spacer(),
                  starButton,
                  editButton,
                  /*InkWell(
                    onTap: (){
                      contacts.removeAt(index);
                      AnimatedListRemovedItemBuilder builder = (context, animation) {
                        // A method to build the Card
                        return buildContactWidget(context, index, list);
                      };
                      if(widget._contactsListKey.currentState != null){
                        widget._contactsListKey.currentState!.removeItem(index, builder);
                      }

                    },
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: MENU_HEADER_TEXT_COLOR,
                    ),
                  ),*/
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: _isEditingMode
                  ? TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: "Name *",
                          labelStyle:
                              TextStyle(color: BLACK_TEXT_COLOR, fontSize: 15)),
                      textInputAction: TextInputAction.done,
                      initialValue: _nameEditingController.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          print('inside validator');
                          return 'Please enter Car add_cars';
                        }
                      },
                      onChanged: (value) {
                        _nameEditingController.text = value;
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text(widget.contact.name),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: _isEditingMode
                  ? TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          labelText: "Phone number *:",
                          labelStyle:
                              TextStyle(color: BLACK_TEXT_COLOR, fontSize: 15)),
                      textInputAction: TextInputAction.done,
                      initialValue: _phoneNumberEditingController.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          print('inside validator');
                          return 'Please enter Car add_cars';
                        }
                      },
                      onChanged: (value) {
                        _phoneNumberEditingController.text = value;
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 10),
                          Text(widget.contact.phoneNumber),
                        ],
                      ),
                    ),
            ),
          ],
        ));
  }

  Widget get subTitleWidget {
    if (_isEditingMode) {
      _phoneNumberEditingController =
          TextEditingController(text: widget.contact.phoneNumber);
      return TextField(
        controller: _phoneNumberEditingController,
      );
    } else
      return Text(widget.contact.phoneNumber);
  }

  Widget get editButton {
    if (_isEditingMode) {
      /*return IconButton(
        icon: Icon(Icons.save),
        onPressed: saveChange,
      );*/
      return TextButton(
        onPressed: saveChange,
        child: Text('SAVE'),
      );
    } else
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleEditMode,
      );
  }

  Widget get starButton {
    if (widget.contact.isFav) {
      return IconButton(
        icon: Icon(Icons.star),
        onPressed: saveFav,
      );
    } else
      return IconButton(
        icon: Icon(Icons.star_border),
        onPressed: saveFav,
      );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void saveChange() {
    widget.contact.name = _nameEditingController.text;
    widget.contact.phoneNumber = _phoneNumberEditingController.text;
    _toggleEditMode();
    widget.onChanged(widget.contact);
  }

  void saveFav() {
    setState(() {
      widget.contact.isFav = !widget.contact.isFav;
    });
    widget.saveFav(widget.contact);
  }
}
