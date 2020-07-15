import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramStories/models/user.dart';

class UserInfo extends StatelessWidget {
  final User user;
  const UserInfo({@required this.user, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(
            user.profileImageUrl,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            user.name,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          iconSize: 30,
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
