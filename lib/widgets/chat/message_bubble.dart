import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userId;
  final String username;
  final String userImageUrl;
  final bool isCurrentUser;
  final Key key;

  MessageBubble(
    this.message,
    this.userId,
    this.username,
    this.userImageUrl,
    this.isCurrentUser, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isCurrentUser)
          CircleAvatar(
            backgroundImage: NetworkImage(
              userImageUrl,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.yellow[300]
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft:
                  !isCurrentUser ? Radius.circular(0) : Radius.circular(12),
              bottomRight:
                  isCurrentUser ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: size.width * 0.2,
            maxWidth: size.width * 0.5,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6.color,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              Text(
                message,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6.color,
                ),
                overflow: TextOverflow.fade,
                softWrap: true,
                textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        if (isCurrentUser)
          CircleAvatar(
            backgroundImage: NetworkImage(
              userImageUrl,
            ),
          ),
      ],
    );
  }
}
