import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:connect/APIS/apis.dart';

import '../../main.dart';
import '../../widgets/GroupMessageTile.dart';
import 'group_info.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupid;
  final String groupname;
  final String username;
  const GroupChatScreen({super.key, required this.groupid, required this.groupname, required this.username});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  Stream <QuerySnapshot>? chats;
  String admin="Unknown";
  TextEditingController messageController = TextEditingController();
  bool _isLoading = true;
  bool _showemogi=false;

  @override
  void initState()  {
    // TODO: implement initState
    chats=API().getChats(widget.groupid);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

    // API().getChats(widget.groupid).then((val){
    //   setState(() {
    //     chats=val;
    //   });
    // });
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() async{
    // await
    await API().getGroupAdmin(widget.groupid).then((val){
      setState(() {
        admin=val.substring(val.indexOf("_") + 1);
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

        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupInfo(groupid: widget.groupid, groupname: widget.groupname, adminname: admin,)));
            },
            icon: const Icon(Icons.info,color: Colors.green,),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
            child: CircularProgressIndicator(),
          )
          :Column(
        children: <Widget>[
          // chat messages here

          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white60,
              child:  Row(

                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _showemogi=!_showemogi;
                                });
                              },
                              icon: Icon(Icons.emoji_emotions_outlined,color: Colors.blueAccent,)),
                          Expanded(
                              child: TextField(
                                minLines: 1,
                                maxLines: 4,
                                controller: messageController,
                                onTap: (){
                                  if(_showemogi) {
                                    setState(() {
                                      _showemogi = !_showemogi;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: 'Enter message',
                                    border: InputBorder.none
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: (){
                      if(messageController.text.isNotEmpty){
                        sendMessage();
                        }
                    },
                    shape:CircleBorder(),
                    minWidth: 0,
                    padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5),
                    child: Icon(Icons.send,color: Colors.blueAccent,size: 32,),)
                ],
              ),
            ),
          ),
          if(_showemogi)
            SizedBox(
              height: mq.height*0.35,
              child: EmojiPicker(
                textEditingController: messageController,
              ),
            ),

        ],
      ),
    );
  }

  chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  sentByMe: widget.username ==
                      snapshot.data.docs[index]['sender']);
            },
          )
              : Container(child: Text("No chats"),);
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      API().sendGroupMessage(widget.groupid, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
