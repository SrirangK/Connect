import 'package:flutter/material.dart';
import 'package:connect/screens/profile/pofile_screen.dart';

import '../../APIS/apis.dart';
import '../../widgets/GroupTile.dart';
import 'search_groups.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {

  Stream? groups=API().getmygroups();
  String groupname='';
  TextEditingController groupnamecontroller=TextEditingController();


  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
            color: Colors.grey,
            height: 0.5,
          ),
        ),
        title: const Text('Communities', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ProfileScreen(user:API.me)));
        }, icon: const Icon(Icons.account_circle_rounded,color: Colors.white,),),

        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchPage()));
            },
            icon: const Icon(Icons.search,color: Colors.white,),
          ),],
      ),
      body: grouplist(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: (){
          popupdialog(context);
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }

  grouplist(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: groups,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data==null || snapshot.data['group'].length==0 ) return Center(child: Text('No Groups',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),));
          return ListView.builder(
            itemCount: snapshot.data['group'].length,
            itemBuilder: (BuildContext context, int index)  {
              int reversedIndex = snapshot.data['group'].length - 1 - index;
              return GroupTile(groupname: getName(snapshot.data['group'][reversedIndex]), groupid: getId(snapshot.data['group'][reversedIndex]));
            },
          );
        },
      ),
    );
  }

  popupdialog(BuildContext context){
    //create group
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Create Group'),
            content: TextField(
              controller: groupnamecontroller,
              decoration: InputDecoration(
                hintText: 'Enter Group Name'
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(onPressed: () async {
                if(groupnamecontroller.text.isNotEmpty)
                  await API().createGroup(API.me.username, API.me.id,
                      groupnamecontroller.text);

                Navigator.pop(context);
                showSnackBar(context, 'Group Created');
              }, child: Text('Create')),
            ],
          );
        }
    );
  }

  void showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}
