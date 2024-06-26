
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/profile/pofile_screen.dart';

import '../../../main.dart';
import '../../APIS/apis.dart';
import '../../models/ChatUser.dart';
import '../../widgets/chat_user card.dart';
import 'All users.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList=[];
  bool _isSearching=false;
  // static FirebaseFirestore firestore =FirebaseFirestore.instance;



  @override
  void initState(){
    super.initState();
    API.getselfinfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),     //For hiding keyboard
      child: WillPopScope(
        //Making Back button work
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen(user:API.me)));
              }, icon: const Icon(Icons.account_circle_rounded,color: Colors.white,),),
              centerTitle: true,
              title: _isSearching ?  TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name,email..',
                  hintStyle: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w100),
                ),
                autofocus: true,
                style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w100),
                //To update search list
                onChanged:(val){
                  _searchList.clear();
                  for (var i in _list){
                    if(i.username.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase()) || i.interest.toLowerCase().contains(val.toLowerCase())){
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                } ,
              )
                  :const Text('MEETUP',style: TextStyle(fontFamily: 'Caveat',color: Colors.white),),


              actions: [
                IconButton(onPressed: () {
                  setState(() {
                    _isSearching= !_isSearching;
                  });
                }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid:Icons.search,color: Colors.white,)),

                IconButton(onPressed: () {
                  _addChatUser();
                }
                    , icon: const Icon(Icons.person_add_outlined,color:Colors.white,))
              ],),


            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) =>const All_users()));
              },
              child: const Icon(Icons.people,color: Colors.white,),
            ),

            body: StreamBuilder(
                stream:API.getmyUsersId() ,
                builder: (context,snapshot){
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    // return const Center(child: CircularProgressIndicator());
                    //if some or all data is loaded
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                          stream:API.getmyusers(snapshot.data?.docs.map((e) => e.id).toList() ??[]),
                          builder: (context, snapshot) {
                            final data = snapshot.data?.docs;
                            _list=data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
                            // var hasuser=_list.length;
                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _isSearching ? _searchList.length : _list.length,
                                  padding: EdgeInsets.only(top: mq.height * 0.015),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(user:_isSearching ? _searchList[index] : _list[index]);
                                  }
                              );
                            } else {
                              return const Center(child: Text('No connections found!',style: TextStyle(fontSize: 30,color: Colors.black),));
                            }
                          }
                      );
                  }
                })
        ),
      ),
    );
  }

  void _addChatUser(){
    String name='';
    showDialog(context: context,
        builder: (_)=>AlertDialog(
          contentPadding:  const EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.person_add,color: Colors.blue,size: 28,),
              Text(' Add user'),
            ],
          ),

          content: TextFormField(
            maxLines: null,
            onChanged: (value)=>name=value,
            decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),
          ),
          actions: [
            MaterialButton(onPressed: (){
              Navigator.pop(context);
            },
              child: const Text('Cancel',style: TextStyle(color: Colors.red,fontSize: 16),),),
            MaterialButton(onPressed: () async {
              Navigator.pop(context);
              if(name.isNotEmpty){
                await API.addChatUser(name).then((value){
                  if(!value){
                    showDialog(
                        context: context,
                        builder: (context){
                          return const AlertDialog(
                            title: Text('User not found!'),
                          );
                        }
                    );
                  }
                });
              }
            },
              child: const Text('ADD',style: TextStyle(color: Colors.blue,fontSize: 16),),)
          ],
        ));
  }
}
