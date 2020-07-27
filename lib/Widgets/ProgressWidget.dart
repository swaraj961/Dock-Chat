import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: AlignmentDirectional.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xff14DAE2)),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: AlignmentDirectional.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.lightGreenAccent,
      ),
    ),
  );
}
