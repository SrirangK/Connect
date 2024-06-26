import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connect/models/ChatUser.dart';
import 'package:connect/screens/profile/view_profile.dart';

import '../Personal_chat/ChatUserScreen.dart';

class Description extends StatelessWidget {

  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  final String title,description,time;
  final ChatUser posted_by;
  Description({Key? key, required this.title, required this.description, required this.time, required this.posted_by}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Description",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
        toolbarHeight: 75,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 60,left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0,bottom: 20),
                      child: Container(child: Text(title,style:GoogleFonts.roboto(fontSize: 35,fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0,bottom: 30),
                      child: Container(child: InkWell(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: posted_by))),
                          child: Text("Posted by: "+posted_by.username,style:GoogleFonts.roboto(fontSize: 20)))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left:0),
                      child: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width/1.4,
                          decoration: BoxDecoration(
        
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey,width: 3)
                          ),
                          child: Text(" "+description,style:GoogleFonts.roboto(fontSize: 25,))),
                    ),
        
                  ],
                ),
        
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon:Icon(Icons.message,color: Colors.white,),
        label: Text('Message '+posted_by.username),
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: posted_by)));},
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
