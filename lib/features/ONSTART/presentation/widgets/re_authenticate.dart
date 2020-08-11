import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/features/ONSTART/presentation/bloc/onstart_bloc.dart';

class ReAuthenticate extends StatelessWidget {
  const ReAuthenticate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Icon(
                Icons.fingerprint,
                color: Colors.black45,
                size: 50,
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(80),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () {
                  BlocProvider.of<OnstartBloc>(context).add(GetLocalAuthDone());
                },
                child: const Text('Retry', style: TextStyle(fontSize: 20)),
              ),
            )),
      ],
    );
  }
}
