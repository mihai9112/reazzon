import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reazzon/src/signup/presentation/bloc/signup.dart';

class SignupContinuePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupContinuePageState();
}

class _SignupContinuePageState extends State<SignupContinuePage> {
  SignupBloc _signUpBloc;

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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Signup", style: TextStyle(color: Colors.blueAccent)),
          centerTitle: true,
        ),
        body: Container(
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
              Flexible(
                child: BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    final reazzons = (state as ReazzonsLoaded)
                      .reazzons;
                    return Container(
                      child: Align(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3.0
                          ),
                          itemBuilder: (context, index){
                            return GestureDetector(
                              child: Card(
                                elevation: 5.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Text(
                                    reazzons[index].value,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontWeight: reazzons[index].isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  )
                                )
                              )
                            );
                          },
                          itemCount: reazzons.length,
                        )
                      )
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
