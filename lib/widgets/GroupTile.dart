import 'package:flutter/material.dart';
import 'package:connect/screens/communities/GroupChatScreen.dart';

import '../APIS/apis.dart';

class GroupTile extends StatefulWidget {
  final String groupname;
  final String groupid;
  const GroupTile({super.key, required this.groupname, required this.groupid});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChatScreen(groupid: widget.groupid, groupname: widget.groupname, username: API.me.username,)));
      },
      child: Container(
          padding: EdgeInsets.only(bottom: 4,left:5,right: 5,top: 5),
          margin: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade400)),),
          child: ListTile(
            leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Text(
                            widget.groupname.substring(0, 1).toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                    ),
            title: Text(
            widget.groupname,
            style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
      ),
    );
  }
}
