import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final Color bgColor;
  final Color borderColor;
  final double width;
  const CustomButton({
    Key key,
    this.onTap,
    @required this.icon,
    @required this.text,
    this.bgColor,
    this.borderColor,
    this.width = 400,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
