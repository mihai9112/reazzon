import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/helpers/field_focus.dart';
import 'package:reazzon/src/models/reazzon.dart';
import 'package:reazzon/src/pages/home_page.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

class SignupContinuePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupContinuePageState();
}

class _SignupContinuePageState extends State<SignupContinuePage> {
  SignupBloc _signUpBloc;
  FocusNode _focusUsername = new FocusNode();

  @override
  void initState() {
    super.initState();
    _signUpBloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  void dispose() {
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if(state is SignupCompleted){
          final route = MaterialPageRoute(builder: (_) => HomePage());
          Navigator.of(context).push(route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Signup", style: TextStyle(color: Colors.blueAccent)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: BlocListener<SignupBloc, SignupState>(
              listener: (context, state){
                if(state is ReazzonLimitSelected){
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(
                      key: Key("snack_bar_limit_reached"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Cannot select more than 3 reazzons'), Icon(Icons.info)],
                      ),
                      backgroundColor: Colors.deepOrangeAccent
                  ));
                }
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
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
                          color: Colors.grey,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.looks_two,
                          color: Colors.grey,
                          size: 30.0,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        EnsureVisibleWhenFocused(
                          focusNode: _focusUsername,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Text(
                                "USERNAME",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Expanded(child: userNameField(_signUpBloc))],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0)
                    ),
                    Flexible(
                      child: BlocBuilder<SignupBloc, SignupState>(
                        builder: (context, state) {
                          var reazzons = new List<Reazzon>();
                          if(state is ReazzonsLoaded){
                            reazzons = state.reazzons;
                          }
                            
                          return Container(
                            height: 280.0,
                            child: Align(
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3.0
                                ),
                                itemBuilder: (context, index){
                                  var reazzon = reazzons[index];
                                  return GestureDetector(
                                    key: Key('${reazzon.id}_${reazzon.value}'),
                                    child: Card(
                                      elevation: 5.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          reazzon.value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: reazzon.isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          key: Key('${reazzon.id}_${reazzon.value}_text'),
                                        )
                                      )
                                    ),
                                    onTap: () => {
                                      reazzon.isSelected ? 
                                      _signUpBloc.add(DeselectReazzon(reazzon)) : 
                                      _signUpBloc.add(SelectReazzon(reazzon)),
                                    }
                                  );
                                },
                                itemCount: reazzons.length,
                              )
                            )
                          );
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: buildCompleteButonWidget(_signUpBloc)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            )
          )
        )
      )
    );
  }
}

Widget userNameField(SignupBloc signupBloc) {
  return StreamBuilder(
    stream: signupBloc.username,
    builder: (context, snapshot) {
      return TextField(
        style: TextStyle(fontSize: 15.0),
        onChanged: signupBloc.changeUsername,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 15.0),
          errorText: snapshot.error,
          prefixText: "@"
        ),
      );
    },
  );
}

buildCompleteButonWidget(SignupBloc signupBloc){
    return StreamBuilder(
      stream: signupBloc.completeValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          key: Key('credentials_button'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blueAccent,
          elevation: 4.0,
          onPressed: () => snapshot.data ? null : signupBloc
            .add(CompleteSignup()),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "COMPLETE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
