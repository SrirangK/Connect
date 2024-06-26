import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect/APIS/apis.dart';
import 'package:connect/main.dart';
import 'package:connect/models/ChatUser.dart';
import 'package:connect/models/message.dart';
import 'package:connect/widgets/message_card.dart';

import '../profile/view_profile.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({Key? key, required this.user,}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list=[];

  final _texteditingcontroller = TextEditingController();

  bool _showemogi = false;
  bool _isuploading=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
      
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
      
          body:Column(
            children: [
              Expanded(
                child: StreamBuilder(
      
                  stream: API.getallmessages(widget.user),
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                    //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      return const SizedBox();
                
                    //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                
                        final data=snapshot.data?.docs;
                        _list =
                            data?.map((e) => Message.fromJson(e.data())).toList() ??[];
      
                        if(_list.isNotEmpty){
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top:mq.height*0.01),
                              itemBuilder: (context,index){
                                return MessageCard(message: _list[index],);
                              });
                        }
                        else{
                          return Center(child: Text('Say Hi!!🤝',style: TextStyle(fontSize: 30,color: Colors.black),));
                        }
                
                    }
                
                  },
                ),
              ),
              if(_isuploading)
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator())
                ),

              _chatinput(),
      
              if(_showemogi)
                SizedBox(
                  height: mq.height*0.35,
                  child: EmojiPicker(
                    textEditingController: _texteditingcontroller,
                    ),
                  ),

            ],
          )
      
        ),
      ),
    );
   }
    Widget _appbar(){

      return Row(
        children: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
          ),
          SizedBox(width: mq.width*0.01,),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*0.3),
            child: CachedNetworkImage(
              width: mq.width*0.1,
              height: mq.height*0.1,
              imageUrl: widget.user.image,
              placeholder: (context, url) =>const  CircularProgressIndicator(),
              errorWidget: (context, url, error) =>  CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.3),
                child: Icon(CupertinoIcons.person),),
            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user,)));
            },
              child: Text(widget.user.username,style: const TextStyle(color: Colors.black,fontSize: 23),))
        ],
      );
    }

    Widget _chatinput(){
      return Padding(
        padding: EdgeInsets.symmetric(vertical:mq.height*0.01,horizontal: mq.width*0.015),
        child: Row(

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
                          controller: _texteditingcontroller,
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
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final List<XFile>? images = await picker.pickMultiImage(imageQuality: 80);
                          for(var i in images!) {
                            setState(() {
                              _isuploading=true;
                            });
                              await API.sendchatimage(widget.user, File(i.path),);
                              setState(() {
                                _isuploading=false;
                              });

                          }
                        },
                        icon: Icon(Icons.image,color: Colors.grey,)),

                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(source: ImageSource.camera , imageQuality: 80);
                          if(image != null){
                              setState(() {
                                _isuploading=true;
                              });
                              await API.sendchatimage(widget.user, File(image.path),);
                              setState(() {
                                _isuploading=false;
                              });
                          }
                        },
                        icon: Icon(Icons.camera,color: Colors.grey,)),

                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: (){
                if(_texteditingcontroller.text.isNotEmpty){
                  if(_list.isEmpty){
                    API.sendFirstmessage(widget.user, _texteditingcontroller.text,Type.text);
                    _texteditingcontroller.text='';
                    API.addChatUser(widget.user.username);
                  }else{
                    API.sendMessage(widget.user, _texteditingcontroller.text,Type.text);
                    _texteditingcontroller.text='';
                  }}
              },
              shape:CircleBorder(),
              minWidth: 0,
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5),
              child: Icon(Icons.send,color: Colors.blueAccent,size: 32,),)
          ],
        ),
      );
    }


}


