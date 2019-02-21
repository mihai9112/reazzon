import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/models/reazzon.dart';

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            Container(height: 20.0),
            Container(padding: const EdgeInsets.all(55.0)),
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
                height: 300.0,
                child: StreamBuilder<List<Reazzon>>(
                  stream: _signUpBloc.outAvailableReazzons,
                  builder: (BuildContext context, AsyncSnapshot<List<Reazzon>> snapshot){
                    return GridView.builder(
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
                    );
                  },
                )
              )
            ),
            Text("...to start meeting people just like you")
          ],
        ),
      )
    );
  }
}
