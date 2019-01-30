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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(height: 20.0),
              Container(padding: const EdgeInsets.all(55.0)),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color:  Colors.black
                  )
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("Your Reazzons"),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black
                              )
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: StreamBuilder(
                                        stream: _appBloc.outAvailableReazzons,
                                        builder: (BuildContext context, AsyncSnapshot<List<Reazzon>> snapshot)
                                        {
                                          if(snapshot.data != null)
                                          {
                                            return RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(color: Colors.black),
                                                children: _buildReazzons(snapshot.data, _signUpBloc)
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

List<TextSpan> _buildReazzons(List<Reazzon> availableReazzons, SignUpBloc signUpBloc)
{
  List<TextSpan> children = [];
  for(var reazzon in availableReazzons)
  {
    children.add(
      TextSpan(
        text: reazzon.value,
        style: new TextStyle(
          color: Colors.blue,
          fontWeight: reazzon.isSelected ? FontWeight.bold : FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
        ..onTap = () {
          print(reazzon.value);
        }
      )
    );
    children.add(
      TextSpan(
        text: " "
      )
    );
  }
  return children;
}