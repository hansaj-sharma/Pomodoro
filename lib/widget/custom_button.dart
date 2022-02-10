import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback? onTap;
  final String? text;


 const CustomButton({ this.onTap, this.text});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap,
        
        child: Text(
          text.toString(),
          style:
          TextStyle(fontSize: 20, color: Colors.white),
        ),
      style:  ElevatedButton.styleFrom(
        padding: EdgeInsets.all(4),
        minimumSize: Size(260.0, 0)
      ),
    );
  }
}
