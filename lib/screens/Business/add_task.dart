import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../APIS/apis.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  addtasktofirebase()async{
    FirebaseAuth auth=FirebaseAuth.instance;
    final User user=await auth.currentUser!;
    String uid=user.uid;
    var time=DateTime.now();
    await FirebaseFirestore.instance
        .collection('business')
        .doc(time.toString()+uid)
        .set({'title':titleController.text,'description':descriptionController.text,'time':time.toString(),'timestamp':time,'posted_by':API.me.id});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(API.me.id)
        .collection('my_posts')
        .doc(time.toString())
        .set({'title':titleController.text,'description':descriptionController.text,'time':time.toString(),'timestamp':time,'posted_by':API.me.id});
    Fluttertoast.showToast(msg: 'Post added successfully');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Headline',
                    border: OutlineInputBorder(
                    )
                ),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder(

                    )
                ),
                maxLines: 15,
                minLines: 10,
              ),
            ),
            SizedBox(height: 10,),
            Container(
                padding: EdgeInsets.all(20),
                height: 90,
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: (){
                      addtasktofirebase();
                    FocusScope.of(context).unfocus();

                    },
                    child:Text('Post',style:
                    TextStyle(fontSize: 18,color: Colors.white
                    )
                    ) )
            )
          ],
        ),
      ),
    );
  }
}
