import 'package:listproject/pages/profile.dart';
import 'package:toast/toast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../networking/networking.dart';
import '../model/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Networking apiCall = Networking();
  bool _isData = false;
  final autoTextKey = GlobalKey<AutoCompleteTextFieldState>();
  final scaffKey = GlobalKey<ScaffoldState>();
  final _textController = TextEditingController();
  List<UserData> userData = [];
  List<String> userName = [];

  Future getData() async {
    List<UserData> listdata = [];
    var data = await apiCall.getApiData();
    data.forEach((ele) {
      listdata.add(UserData.getUserData(ele));
    });
    setState(() {
      userData = listdata;
      _isData = true;
    });
    userData.forEach((ele) {
      userName.add(ele.name);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isData
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AutoCompleteTextField(
                      key: autoTextKey,
                      controller: _textController,
                      clearOnSubmit: true,
                      suggestions: userName,
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      itemSorter: (a, b) {
                        return a.compareTo(b);
                      },
                      itemFilter: (item, query) {
                        return item
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSubmitted: (suggestion) {
                        var index = userData
                            .indexWhere((note) => note.name == suggestion);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Profile(userProfile: userData[index]),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Name....',
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, item) => Padding(
                        padding: item % 2 == 0
                            ? const EdgeInsets.only(right: 30.0, bottom: 10.0)
                            : const EdgeInsets.only(left: 30.0, bottom: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              side: BorderSide(
                                  width: 1.0, color: Colors.black87)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Name: ${userData[item].name}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Text(
                                        'Name:- ${userData[item].email}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Text(
                                        '${userData[item].address.street},${userData[item].address.suite},${userData[item].address.city},${userData[item].address.zipcode}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          '${userData[item].phone}',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                      Text(
                                        'anastasia.net',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.red,
                                  size: 35.0,
                                ),
                                onPressed: () {
                                  Toast.show(
                                    'User Deleted',
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    userData.removeAt(item);
                                    userName.removeAt(item);
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      itemCount: userData.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 10.0,
                ),
              ),
      ),
    );
  }
}
