import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/pages/account.dart';

class ThirdSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ThirdSignUpPageState();
}

class _ThirdSignUpPageState extends State<ThirdSignUpPage> {
  SignUpBloc _signUpBloc;

   @override
  void initState()
  {
    super.initState();
    _signUpBloc = new SignUpBloc();
    _signUpBloc.loadReazzons();
  }

  @override
  void dispose()
  {
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Signup", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100.0,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.looks_one,
                  size: 30.0,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.trending_flat,
                  color: Colors.blueAccent,
                  size: 30.0,
                ),
                Icon(
                  Icons.looks_two,
                  color: Colors.grey,
                  size: 30.0,
                ),
                Icon(
                  Icons.trending_flat,
                  color: Colors.blueAccent,
                  size: 30.0,
                ),
                Icon(
                  Icons.looks_3,
                  size: 50.0,
                  color: Colors.blueAccent,
                )
              ],
            ),
            Text("Hello ${_appBloc.currentUser.userName}"),
            Container(
              child: StreamBuilder<String>(
                stream: _signUpBloc.outReazzonMessage,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                  return snapshot.hasData ? Text(snapshot.data) : null;
                },
                initialData: "Select at least 1 reazzon",
              )
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: Colors.black
                  )
                ),
                height: 280.0,
                child: StreamBuilder<List<Reazzon>>(
                  stream: _signUpBloc.outAvailableReazzons,
                  builder: (BuildContext context, AsyncSnapshot<List<Reazzon>> snapshot){
                    return Align(
                      alignment: Alignment.center,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3.0
                        ),
                        itemBuilder: (BuildContext context, int index){
                          var reazzon = snapshot.data[index];
                          return GestureDetector(
                            child: Card(
                              elevation: 5.0,
                              child: Container(
                                alignment: Alignment.center,
                                child: new Text(reazzon.value,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(fontWeight: reazzon.isSelected ? FontWeight.bold : FontWeight.normal),
                                ),
                              ),
                            ),
                            onTap: () {
                              var isLessThen3 = snapshot.data.where((reazzon) => reazzon.isSelected).length < 3;
                              var originalValue = reazzon.isSelected;

                              if(!reazzon.isSelected && isLessThen3){
                                reazzon.select();
                                _signUpBloc.updateReazzons(snapshot.data);
                              }
                              else{
                                reazzon.deselect();
                                _signUpBloc.updateReazzons(snapshot.data);
                              }

                              if(reazzon.isSelected && !isLessThen3) {
                                reazzon.deselect();
                                _signUpBloc.updateReazzons(snapshot.data);
                              }
                                
                              if(originalValue == reazzon.isSelected && !isLessThen3)
                                _signUpBloc.inReazzonMessage("No more then 3 reazzon to be selected");
                            },
                          );
                        },
                        itemCount: (snapshot.data == null ? 0 : snapshot.data.length),
                      )
                    );
                  },
                )
              )
            ),
            Text("...to start meeting people just like you"),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: completeRegistrationButton(_signUpBloc, _appBloc),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

Widget completeRegistrationButton(SignUpBloc signUpBloc, ApplicationBloc appBloc){
  return StreamBuilder(
    stream: signUpBloc.completeRegistrationValid,
    initialData: false,
    builder: (context, snapshot){
      return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueAccent,
        elevation: 4.0,
        onPressed: snapshot.data ? () {
          signUpBloc.completeRegistration(appBloc.currentUser).then((user) {
            appBloc.updateUser(user);
            var accountRoute = MaterialPageRoute(
              builder: (BuildContext context) => AccountPage()
            );
            Navigator.of(context)
              .pushAndRemoveUntil(accountRoute, ModalRoute.withName('/account'));
          });
        }
        : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 20.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "COMPLETE SIGNUP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        )
      );
    },
  );
}
