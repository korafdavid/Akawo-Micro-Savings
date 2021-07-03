import 'package:akawo/about_app.dart';
import 'package:akawo/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:akawo/contact.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DatabaseHelper _dbHelper;

  List<Contact> _contacts = [];
  List<Contact> contactForDisplay = [];
  final _formkey = GlobalKey<FormState>();
  Contact _contact = Contact();
  final _ctrlName = TextEditingController();
  final _ctrlAddress = TextEditingController();
  final _ctrlMobile = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlSearch = TextEditingController();
  final _ctrlAdd = TextEditingController();
  final _ctrlRemove = TextEditingController();

  int index;
  int addAmount;
  int changeAmount;
  int removeAmount;
  bool sendAlert = true;
  //int _total;

  @override
  void initState() {
    super.initState();
    contactForDisplay = _contacts;
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });

    // _calcTotal();
    _refreshContactList();
  }

  // ignore: unused_element
  _initialContent() {
    return SafeArea(
      child: Center(
        child: Text(
          'Click on Button below to create Database!',
          style: TextStyle(color: Colors.black26),
        ),
      ),
    );
  }

  mainContent() {
    return SafeArea(
      child: Column(
        children: [
          _searchBar(),
          mainContainer(),
          //Text(_total != null ? _total : 'waiting ...')
        ],
      ),
    );
  }

  void showGeneralDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height * .50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(children: [
                        TextFormField(
                          controller: _ctrlName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(hintText: 'Full Name'),
                          onSaved: (val) => setState(() => _contact.name = val),
                          validator: (val) => (val.length == 0
                              ? 'This field is required'
                              : null),
                        ),
                        TextFormField(
                          controller: _ctrlAddress,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(hintText: 'Address'),
                          onSaved: (val) =>
                              setState(() => _contact.address = val),
                          validator: (val) => (val.length == 0
                              ? 'This field is required'
                              : null),
                        ),
                        TextFormField(
                          controller: _ctrlMobile,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText: 'Mobile'),
                          onSaved: (val) =>
                              setState(() => _contact.mobile = val),
                          validator: (val) => (val.length < 11
                              ? 'A Valid Phone Number is Required'
                              : null),
                        ),
                        TextFormField(
                          controller: _ctrlAmount,
                          keyboardType: TextInputType.phone,
                          decoration:
                              InputDecoration(hintText: 'Initial Amount'),
                          validator: (val) => (val.length < 3
                              ? 'least amount required is #100'
                              : null),
                          onSaved: (val) =>
                              setState(() => _contact.amount = val),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: MaterialButton(
                        onPressed: () async {
                          await _onSubmit();

                          String message = '''
  <<<<<<MICROFINANCE SAVINGS>>>>>>
  <<<<<< NEW ACCOUNT CREATED >>>>>>
  NAME: ${_contact.name}
  
 BALANCE(NGN): ₦${_contact.amount}
  THANKS FOR YOUR PATRONAGE
  ''';
                          List<String> recipents = ['${_contact.mobile}'];

                          var form = _formkey.currentState;
                          if (form.validate()) {
                            if (sendAlert == true) {
                              _sendSMS(message, recipents);
                            }
                          }
                        },
                        child: Text("Add"),
                        color: Colors.purpleAccent,
                        textColor: Colors.white,
                        elevation: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Akawo'),
        centerTitle: true,
        //actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
              ),
              child: Center(
                  child: Text('Akawo',
                      style: TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                          fontFamily: "Tourney"))),
            ),
            ListTile(
              leading: Icon(Icons.more),
              title: Text('About App'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.send),
              title: Text('Generate Alert'),
              trailing: Switch(
                activeColor: Colors.purple,
                value: sendAlert,
                onChanged: (value) async {
                  setState(() {
                    sendAlert = value;

                    print(sendAlert);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Terms & Conditions'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('help & feedback'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share the App'),
              onTap: () {},
            )
          ],
        ),
      ),
      body: mainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showGeneralDialog(context);
        },
        tooltip: 'Add Persons',
        child: Icon(Icons.person_add),
      ),
    );
  }

  void showToast(String toastMessage, Color toastColor) {
    Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: toastColor,
        textColor: Colors.white);
  }

  _refreshContactList() async {
    List<Contact> ref = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = ref;
      contactForDisplay = ref;
    });
  }

  // loadScreen() {
  //   return setState(() {
  //     index == 0 ? _initialContent() : mainContent();
  //   });
  // }

  // void _calcTotal() async {
  //   var total = (await _dbHelper.calculateTotal())[0]['Total'];
  //   print(total);
  //   setState(() {
  //     _total = total;
  //   });
  // }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _resetForm() {
    setState(() {
      print(_formkey.currentState);
      _formkey.currentState.reset();
      _ctrlName.clear();
      _ctrlAddress.clear();
      _ctrlMobile.clear();
      _ctrlAmount.clear();
      _contact.id = null;
    });
  }

  _onSubmit() async {
    var form = _formkey.currentState;
    if (form.validate()) {
      // dynamic contactName = _ctrlName.text.toLowerCase();
      // if (contactName.contains(_ctrlName)) {
      //   showToast('This Name Already Exits, Please Add an Initial', Colors.red);
      // }
      form.save();

      if (_contact.id == null)
        await _dbHelper.insertContact(_contact);
      else
        await _dbHelper.updateContact(_contact);

      _refreshContactList();

      _resetForm();
      Navigator.of(context).pop();
    }
  }

  _onChangeSubmit() async {
    await _dbHelper.updateContact(_contact);
    _refreshContactList();
    _resetForm();
    Navigator.of(context).pop();
  }

  // futureData() {
  //   return FutureBuilder<List<_contact>>(
  //     future: _contacts,
  //     initialData: [],
  //     builder: (BuildContext context, AsyncSnapshot<List<_contact>> snapshot) {
  //       return snapshot.hasData
  //           ? mainContainer()
  //           : Center(
  //               child: Text('Click on the Button below to create a Record'));
  //     },
  //   );
  // }

  //MainListView Container
  mainContainer() => Expanded(
        child: ListView.builder(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: contactForDisplay.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white, blurRadius: 15, spreadRadius: 5)
                  ],
                  color: Colors.purpleAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: 'Name:  ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                            children: [
                          TextSpan(
                              text: contactForDisplay[index].name.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                              ))
                        ])),
                    RichText(
                        text: TextSpan(
                            text: 'Address:  ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                            children: [
                          TextSpan(
                              text: _contacts[index].address,
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                              ))
                        ])),
                    RichText(
                        text: TextSpan(
                            text: 'Amount:   ₦',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                            children: [
                          TextSpan(
                              text: _contacts[index].amount,
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                              ))
                        ])),
                    RichText(
                        text: TextSpan(
                            text: 'Tele:  ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                            children: [
                          TextSpan(
                              text: _contacts[index].mobile,
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 2,
                              ))
                        ])),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Edit Icon and Properties
                          IconButton(
                              icon: Icon(Icons.edit),
                              tooltip: 'edit',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0)), //this right here
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Form(
                                                  key: _formkey,
                                                  child: Column(children: [
                                                    TextFormField(
                                                      controller: _ctrlName,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'Name'),
                                                      onSaved: (val) =>
                                                          setState(() =>
                                                              _contact.name =
                                                                  val),
                                                      validator: (val) => (val
                                                                  .length ==
                                                              0
                                                          ? 'This field is required'
                                                          : null),
                                                    ),
                                                    TextFormField(
                                                      controller: _ctrlAddress,
                                                      keyboardType:
                                                          TextInputType
                                                              .streetAddress,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Address'),
                                                      onSaved: (val) =>
                                                          setState(() =>
                                                              _contact.address =
                                                                  val),
                                                      validator: (val) => (val
                                                                  .length ==
                                                              0
                                                          ? 'This field is required'
                                                          : null),
                                                    ),
                                                    TextFormField(
                                                      controller: _ctrlMobile,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: 'Tele'),
                                                      onSaved: (val) =>
                                                          setState(() =>
                                                              _contact.mobile =
                                                                  val),
                                                      validator: (val) => (val
                                                                  .length <
                                                              11
                                                          ? 'This field is required'
                                                          : null),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 320.0,
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      _onSubmit();
                                                      String message = '''
  <<<<<<MICRO FINANCE SAVINGS>>>>>>
  <<<<<<ACCOUNT PROFILE UPDATE >>>>>>
  NAME: ${_contact.name}
  ADDRESS: ${_contact.address}
  TELE: ${_contact.mobile}
 BALANCE(NGN): ₦${_contact.amount}
  THANKS FOR YOUR PATRONAGE
  ''';
                                                      List<String> recipents = [
                                                        '${_contact.mobile}'
                                                      ];

                                                      var form =
                                                          _formkey.currentState;
                                                      if (form.validate()) {
                                                        if (sendAlert == true) {
                                                          _sendSMS(message,
                                                              recipents);
                                                        }
                                                      }
                                                      showToast(
                                                          'Account Details Edit Successful',
                                                          Colors.green);
                                                    },
                                                    child: Text("EDIT DETAILS"),
                                                    color: Colors.purpleAccent,
                                                    textColor: Colors.white,
                                                    elevation: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                setState(() {
                                  _contact = _contacts[index];
                                  _ctrlName.text = _contacts[index].name;
                                  _ctrlAddress.text = _contacts[index].address;
                                  _ctrlMobile.text = _contacts[index].mobile;
                                });
                              }),
                          //Deposit Icon and Properties
                          IconButton(
                              icon: Icon(Icons.add),
                              tooltip: 'Deposit',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0)), //this right here
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .20,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Form(
                                                  key: _formkey,
                                                  child: Column(children: [
                                                    TextFormField(
                                                      controller: _ctrlAdd,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Amount'),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 320.0,
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      setState(() async {
                                                        changeAmount =
                                                            int.parse(
                                                                _contacts[index]
                                                                    .amount);

                                                        addAmount =
                                                            changeAmount +=
                                                                int.parse(
                                                                    _ctrlAdd
                                                                        .text);

                                                        _contacts[index]
                                                                .amount =
                                                            '$addAmount';

                                                        _contact =
                                                            _contacts[index];
                                                        _onChangeSubmit();
                                                        String message = '''
  <<<<<<MICRO FINANCE SAVINGS>>>>>>
  <<<<<< ACCOUNT DEPOSIT >>>>>>
  NAME: ${_contact.name}
  DEPOSIT: ₦${_ctrlAdd.text}
 BALANCE(NGN): ₦${_contact.amount}
  THANKS FOR YOUR PATRONAGE
  ''';
                                                        List<String> recipents =
                                                            [
                                                          '${_contact.mobile}'
                                                        ];
                                                        showToast(
                                                            'Account Deposit Successful',
                                                            Colors.green);
                                                        var form = _formkey
                                                            .currentState;
                                                        if (form.validate()) {
                                                          if (sendAlert ==
                                                              true) {
                                                            _sendSMS(message,
                                                                recipents);
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Text("DEPOSIT"),
                                                    color: Colors.purpleAccent,
                                                    textColor: Colors.white,
                                                    elevation: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          // Withdrawal Icon and Properties
                          IconButton(
                              icon: Icon(Icons.remove),
                              tooltip: 'Withdrawal',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0)), //this right here
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .20,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Form(
                                                  key: _formkey,
                                                  child: Column(children: [
                                                    TextFormField(
                                                      controller: _ctrlRemove,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Amount'),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 320.0,
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        changeAmount =
                                                            int.parse(
                                                                _contacts[index]
                                                                    .amount);

                                                        if (changeAmount >
                                                            int.parse(
                                                                _ctrlRemove
                                                                    .text)) {
                                                          removeAmount =
                                                              changeAmount -=
                                                                  int.parse(
                                                                      _ctrlRemove
                                                                          .text);
                                                          _contacts[index]
                                                                  .amount =
                                                              '$removeAmount';
                                                          if (removeAmount <
                                                              0) {
                                                            removeAmount = 0;
                                                          }

                                                          _contact =
                                                              _contacts[index];
                                                          _onChangeSubmit();
                                                          String message = '''
  <<<<<<MICRO FINANCE SAVINGS>>>>>>
  <<<<<< ACCOUNT WITHDRAWAL >>>>>>
  NAME: ${_contact.name}
  DEPOSIT: ₦${_ctrlRemove.text}
 BALANCE(NGN): ₦${_contact.amount}
  THANKS FOR YOUR PATRONAGE
  ''';
                                                          List<String>
                                                              recipents = [
                                                            '${_contact.mobile}'
                                                          ];
                                                          showToast(
                                                              'Withdrawal Successful',
                                                              Colors.green);

                                                          var form = _formkey
                                                              .currentState;
                                                          if (form.validate()) {
                                                            if (sendAlert ==
                                                                true) {
                                                              _sendSMS(message,
                                                                  recipents);
                                                            }
                                                          }
                                                        } else {
                                                          showToast(
                                                              'Insufficent Fund',
                                                              Colors.red);
                                                        }
                                                      });
                                                    },
                                                    child: Text("WITHDRAWAL"),
                                                    color: Colors.purpleAccent,
                                                    textColor: Colors.white,
                                                    elevation: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          //Delete icon and Properties
                          IconButton(
                              icon: Icon(Icons.delete),
                              tooltip: 'Delete',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Are you sure you want to delete this Info?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () async {
                                                await _dbHelper.deleteContact(
                                                    _contacts[index].id);

                                                _refreshContactList();
                                                String message = '''
    MICRO FINANCE SAVINGS
  <<<<<< ACCOUNT DELETE >>>
  Dear ${_contact.name} your Account with us have been Deleted
  Thanks for Partnering with us, if you are unaware of this Action, Please Kindly Notify Us!
  
  BALANCE: ${_contact.amount}
  THANKS FOR YOUR PATRONAGE
  ''';
                                                List<String> recipents = [
                                                  '${_contact.mobile}'
                                                ];

                                                if (sendAlert == true) {
                                                  _sendSMS(message, recipents);
                                                }
                                                showToast(
                                                    'Account Delete was Successful',
                                                    Colors.green);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Delete'))
                                        ],
                                      );
                                    });
                              })
                        ])
                  ],
                ),
              );
            }),
      );

  _searchBar() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.4)
          ],
          borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        controller: _ctrlSearch,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Search',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search, color: Colors.purple),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(25))),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            contactForDisplay = _contacts.where((_contact) {
              dynamic contactName = _contact.name.toLowerCase();
              return contactName.contains(text);
            }).toList();
          });
        },
      ),
    );
  }
}
