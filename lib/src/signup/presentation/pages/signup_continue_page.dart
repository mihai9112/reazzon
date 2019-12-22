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
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
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
      child: Scaffold(
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
                            var reazzon = reazzons[index];
                            return GestureDetector(
                              key: Key('${reazzon.id}_${reazzon.value}'),
                              child: Card(
                                elevation: 5.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Text(
                                    reazzon.value,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
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
              )
            ],
          ),
        )
      ),
    );
  }
}
