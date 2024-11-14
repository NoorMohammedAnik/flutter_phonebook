import 'package:flutter/material.dart';


class ProgressDialog extends StatelessWidget
{
  const ProgressDialog({super.key});


  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            width: 100.0,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                strokeWidth: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
