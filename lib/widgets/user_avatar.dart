import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: Colors.white,
        ),
        image: DecorationImage(
          // image: NetworkImage(url), // TODO: check "https://" in url
          image: AssetImage(url),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
