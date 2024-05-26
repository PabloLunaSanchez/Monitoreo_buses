import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({ Key? key,required this.imageUrl }) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 81, 136, 184),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,offset: Offset(0,2),blurRadius: 0.6
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imageUrl),
          )
        ),
      ),
    );
  }
}