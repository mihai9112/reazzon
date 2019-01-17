import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class ThirdSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ApplicationBloc _appBloc = BlocProvider.of<ApplicationBloc>(context);

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
                                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot)
                                        {
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: TextStyle(color: Colors.black),
                                              children: _buildReazzons(snapshot.data)
                                            ),
                                          );
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

  List<TextSpan> _buildReazzons(List<String> availableReazzons)
  {
    List<TextSpan> children = [];
    for(var reazzon in availableReazzons)
    {
      children.add(
        TextSpan(
          text: reazzon,
          style: new TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
          ..onTap = () {
            print(reazzon);
          }
        )
      );
    }
    return children;
  }

  Widget _streamReazzons(ApplicationBloc appBloc)
  {
    return StreamBuilder(
      stream: appBloc.outAvailableReazzons,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot){
        if(!snapshot.hasData)
        {
          Text('poop');
        }
        else
        {
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: _buildReazzons(snapshot.data)
            ),
          );
        }
      },
    );
  }
}