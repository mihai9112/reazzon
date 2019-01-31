import 'package:flutter/gestures.dart';
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
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color:  Colors.black
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: StreamBuilder<List<Reazzon>>(
                        stream: _appBloc.outAvailableReazzons,
                        builder: (BuildContext context, AsyncSnapshot<List<Reazzon>> snapshot){
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2.0
                            ),
                            itemBuilder: (BuildContext context, int index){
                              var reazzon = snapshot.data[index];
                              return GestureDetector(
                                child: Card(
                                  elevation: 5.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: new Text(reazzon.value),
                                  ),
                                ),
                              );
                            },
                            itemCount: (snapshot.data == null ? 0 : snapshot.data.length),
                          );
                        },
                      )
                    )
                  ],
                ), 
              )
            )
          ],
        ),
      )
    );
  }
}
