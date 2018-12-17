import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';
import 'package:reazzon/src/blocs/signup_bloc.dart';
import 'package:reazzon/src/helpers/fieldFocus.dart';

class SecondSignUpPage  extends StatelessWidget {
  SecondSignUpPage({
    @required this.signUpBloc,
  });

  final SignUpBloc signUpBloc;

  @override
  Widget build(BuildContext context) {
    FocusNode _firstName = new FocusNode();

    final ApplicationBloc appBloc = BlocProvider.of<ApplicationBloc>(context);
  
    return Scaffold(
      body: new SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              Text(appBloc.reazzonUser.userId),
              Container(
                padding: EdgeInsets.all(55.0),
              ),
              Row(
                children: <Widget>[
                  EnsureVisibleWhenFocused(
                    focusNode: _firstName,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          "FIRST NAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: firstNameField(signUpBloc)
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstNameField(SignUpBloc bloc) {
    return StreamBuilder(
      stream: bloc.outFirstName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.inFirstName,
          decoration: InputDecoration(
            errorText: snapshot.error,
          ),
        );
      },
    );
  }
}