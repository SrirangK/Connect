import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../APIS/apis.dart';
import '../../Authentication/LoginPage.dart';
import '../../main.dart';
import '../../models/ChatUser.dart';
import '../Personal_chat/ChatUserScreen.dart';


class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

Future<void> _signOut (BuildContext context) async{
  await API.auth.signOut();
  Navigator.pop(context,
      MaterialPageRoute(builder: (_) =>  LoginPage()));
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      //for hiding keyboard
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: WillPopScope(                     //Going back to home screen
        onWillPop: (){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) =>ChatScreen(user: widget.user,)));
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title:  Text(widget.user.username,style: const TextStyle(color: Colors.white,fontSize: 30),),
              backgroundColor: Colors.black,
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),),

            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
              child: SingleChildScrollView(
                child: Column(children:[
                  SizedBox(width: mq.width,height: mq.height*0.03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height),
                    child: CachedNetworkImage(
                      width: mq.height*0.2,
                      height: mq.height*0.2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon( Icons.person),),
                    ),
                  ),

                  //for adding some space
                  SizedBox(height: mq.height*0.03),
                  Text("Email: "+widget.user.email,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                  //for adding some space
                  SizedBox(height: mq.height*0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Status: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 18),),
                      Text(widget.user.status,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: mq.height*0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Interests: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 18),),
                      Text(widget.user.interest,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                    ],
                  ),
                ]),
              ),
            )
        ),
      ),
    );

  }



}
