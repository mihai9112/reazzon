import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';

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

    final ApplicationBloc _appBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      body: new SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              Container(height: 20.0),
              Container(
                padding: EdgeInsets.all(55.0),
              ),
              Row(
                children: <Widget>[
                  Flexible(child: 
                    RichText(
                      text: TextSpan(
                        children: _buildReazzons(_appBloc.availableReazzons)
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
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
            decoration: TextDecoration.underline
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
}