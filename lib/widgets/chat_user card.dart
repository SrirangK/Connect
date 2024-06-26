import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connect/main.dart';
import 'package:connect/models/ChatUser.dart';
import 'package:connect/screens/Personal_chat/ChatUserScreen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user))),
      child: Container(
        padding: EdgeInsets.only(bottom: 4,left:5,right: 5),
      margin: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      border: Border(
          bottom: BorderSide(color: Colors.grey.shade400)),),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height),
            child: CachedNetworkImage(
              width: mq.height*0.063,
              height: mq.height*0.065,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>  CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  widget.user.username.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                ),
            ),
          ),
          title: Text(widget.user.username,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          subtitle: Text("likes: "+widget.user.interest),
        ),
      ),
    );
  }
}
