import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reazzon/src/blocs/application_bloc.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appBloc = BlocProvider.of<ApplicationBloc>(context);
    var stringBuilder = new StringBuffer();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Overview", style: TextStyle(color: Colors.blueAccent)),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: _appBloc.outCurrentUser,
            builder: (context, snapshot){
              if(snapshot.hasData){
                snapshot.data.selectedReazzons.forEach((f) {
                  stringBuilder.write(f.value);
                  stringBuilder.write("; ");
                });

                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(height: 20.0),
                      Container(padding: const EdgeInsets.all(55.0)),
                      Text(snapshot.data.firstName),
                      Text(snapshot.data.lastName),
                      Text(snapshot.data.userName),
                      Text(stringBuilder.toString())
                    ],
                  )
                );
              }
              return Container();
            },
          )
        ),
      ),
    );
  }
}