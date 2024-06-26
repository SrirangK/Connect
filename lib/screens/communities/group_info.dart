import 'package:flutter/material.dart';
import 'package:connect/APIS/apis.dart';

import 'group_chat_pagr.dart';

class GroupInfo extends StatefulWidget {
  final String groupid;
  final String groupname;
  final String adminname;
  const GroupInfo({super.key, required this.groupid, required this.groupname, required this.adminname});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    // TODO: implement initState
    getmembers();
    super.initState();
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getmembers() async{
    //get members of the group
    await API().getGroupMembers(widget.groupid).then((val){
      setState(() {
        members=val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.groupname),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading:IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                        const Text("Are you sure you exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              API()
                                  .toggleGroupJoin(
                                  widget.groupid,
                                  getName(API.me.username),
                                  widget.groupname)
                                  .whenComplete(() {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>GroupChatPage()) );
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            ListTile(
              title: Text('Admin: ${widget.adminname}'),
            ),
            const Divider(),
            const SizedBox(height: 10,),
            const Text('Members', style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            memberList(),
          ],
        ),
      ),
    );

  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      // subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
        }
      },
    );
  }
}
