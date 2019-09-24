import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';
import 'package:reazzon/src/helpers/spinner.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/settings/setting_bloc.dart';

class SettingPage extends StatefulWidget {
  final SettingUserModel user;
  SettingPage(this.user);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingsBloc settingBloc;

  static const int FIRST_NAME = 0;
  static const int LAST_NAME = 1;
  static const int USER_NAME = 2;
  static const int EMAIL = 3;

  @override
  void initState() {
    settingBloc = BlocProvider.of<SettingsBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    settingBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEEEEEE),
      body: ListView(
        children: <Widget>[
          // top section
          Material(
            elevation: 8,
            shadowColor: Colors.blueAccent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              color: Colors.blueAccent,
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 104,
                        width: 102,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0XFFDDDDDD), width: 4),
                          borderRadius: BorderRadius.circular(96),
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(96),
                          child: Container(
                            color: Colors.grey,
                            child: Image.network(
                              'https://rukminim1.flixcart.com/image/352/352/poster/m/j/f/cute-new-born-baby-non-tearable-synthetic-sheet-poster-pb008-original-imae7qvrnsygcwg6.jpeg',
                              height: 92,
                              width: 92,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  offset: Offset(0.5, 1.5),
                                  spreadRadius: 2,
                                  color: Colors.black12,
                                )
                              ]),
                          child: GestureDetector(
                            onTap: () {
                              print('Edit photo');
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            width: 80,
                                            height: 7,
                                            decoration: BoxDecoration(
                                                color: Color(0XFFeeedee),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: double.infinity,
                                            child: OutlineButton(
                                              padding: EdgeInsets.all(16),
                                              borderSide: BorderSide(
                                                  color: Colors.black45),
                                              child: Text('Take a photo'),
                                              onPressed: () {
                                                print('Take a photo clicked');
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            child: OutlineButton(
                                              borderSide: BorderSide(
                                                  color: Colors.black45),
                                              padding: EdgeInsets.all(16),
                                              child:
                                                  Text('Choose from gallery'),
                                              onPressed: () {
                                                print(
                                                    'Choose from gallery clicked');
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.photo_camera,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this.widget.user.firstName +
                            ' ' +
                            this.widget.user.lastName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        this.widget.user.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18),
          _itemBuilder(this.widget.user.email, EMAIL),
          _itemPasswordBuilder(),
          SizedBox(height: 16),
          _itemBuilder(this.widget.user.firstName, FIRST_NAME),
          _itemBuilder(this.widget.user.lastName, LAST_NAME),
          _itemBuilder(this.widget.user.userName, USER_NAME),
          SizedBox(height: 16),
          _reazzonsBuilder(this.widget.user.reazzons),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _reazzonsBuilder(List<String> reazzons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Reazzons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                  SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        (reazzons.length),
                        (value) => Text(reazzons[value],
                            style: TextStyle(
                              color: Colors.black54,
                            ))),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(String value, int index) {
    String key;
    Widget _child;

    switch (index) {
      case FIRST_NAME:
        key = 'FIRST NAME';
        _child = _ModalBuilder(
          initialData: value,
          onSubmit: settingBloc.changeFirstName,
          input: settingBloc.inFirstName,
          output: settingBloc.outFirstName,
        );
        break;
      case LAST_NAME:
        key = 'LAST NAME';
        _child = _ModalBuilder(
          initialData: value,
          onSubmit: settingBloc.changeLastName,
          input: settingBloc.inLastName,
          output: settingBloc.outLastName,
        );
        break;
      case USER_NAME:
        key = 'USER NAME';
        _child = _ModalBuilder(
          initialData: value,
          onSubmit: settingBloc.changeUserName,
          input: settingBloc.inUserName,
          output: settingBloc.outUserName,
        );
        break;
      case EMAIL:
        key = 'EMAIL';
        _child = _ModalBuilder(
          initialData: value,
          onSubmit: settingBloc.changeEmail,
          input: settingBloc.inEmail,
          output: settingBloc.outEmail,
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                  Text(value,
                      style: TextStyle(
                        color: Colors.black54,
                      )),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          _dialogBuilder(title: key, child: _child));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemPasswordBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('PASSWORD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => _dialogBuilder(
                            title: 'PASSWORD',
                            child: Container(
                              color: Colors.orangeAccent,
                              height: 200,
                            ),
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//  -- modal --

  /*
  Widget _passwordModalBuilder() {
    return Container(
      child: StreamBuilder(
          stream: output,
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                Material(
                  child: TextField(
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                      hintText: initialData,
                      hintStyle: TextStyle(color: Colors.black87),
                      errorStyle: TextStyle(fontSize: 12.0),
                      errorText: snapshot.error,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Color(0XFFAAAAAA),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Color(0XFFCCCCCC),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onChanged: input,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: snapshot.hasError ? null : () => settingBloc.changePassword(),
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                            color:
                            snapshot.hasError ? Colors.grey : Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
  */

  // -- dialog --
  Dialog _dialogBuilder({
    @required String title,
    @required Widget child,
  }) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 16),
              child,
            ],
          ),
        ));
  }
}

class _ModalBuilder extends StatefulWidget {
  final Stream<String> output;
  final Function(String) input;
  final String initialData;
  final Function onSubmit;

  _ModalBuilder({
    this.output,
    this.initialData,
    this.input,
    this.onSubmit,
  });

  @override
  __ModalBuilderState createState() => __ModalBuilderState();
}

class __ModalBuilderState extends State<_ModalBuilder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: StreamBuilder(
              stream: widget.output,
              builder: (context, snapshot) {
                return Column(
                  children: <Widget>[
                    Material(
                      child: TextField(
                        style: TextStyle(fontSize: 15.0),
                        decoration: InputDecoration(
                          hintText: widget.initialData,
                          hintStyle: TextStyle(color: Colors.black87),
                          errorStyle: TextStyle(fontSize: 12.0),
                          errorText: snapshot.error,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Color(0XFFAAAAAA),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Color(0XFFCCCCCC),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: widget.input,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: snapshot.hasError
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool _success = await widget.onSubmit();
                                  setState(() {
                                    isLoading = false;
                                    if (_success) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                          child: Text(
                            'UPDATE',
                            style: TextStyle(
                                color: snapshot.hasError
                                    ? Colors.grey
                                    : Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: (isLoading != null && isLoading == true)
              ? Container(
                  color: Colors.white,
                  child: Center(child: Spinner()),
                )
              : Container(),
        ),
      ],
    );
  }
}
