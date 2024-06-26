import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connect/models/ChatUser.dart';

import '../../APIS/apis.dart';
import 'add_task.dart';
import 'description.dart';

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({Key? key}) : super(key: key);

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  String uid=API.auth.currentUser!.uid;
  @override
  void initState() {
    super.initState();
  }
  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('business').snapshots(),
          builder: (context,snapshots){
            if(snapshots.connectionState==ConnectionState.waiting){
              return Center(
                  child: CircularProgressIndicator(color: Colors.black,)
              );
            }
            else{
              final docs=snapshots.data!.docs;
              return ListView.builder(itemCount:docs.length ,
                itemBuilder: (context,index){
                  var time=(docs[index]['timestamp'] as Timestamp).toDate();

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FutureBuilder<Map<String, dynamic>>(
                            future: getUserData(docs[index]['posted_by']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Scaffold(
                                  body: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Scaffold(
                                  body: Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  ),
                                );
                              } else {
                                return Description(
                                  title: docs[index]['title'],
                                  description: docs[index]['description'],
                                  time: docs[index]['time'],
                                  posted_by: ChatUser.fromJson(snapshot.data!),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                  margin: EdgeInsets.only(left: 20,),
                                  child: Text("Title: "+docs[index]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
                              SizedBox(height: 5,),
                              Container(
                                margin: EdgeInsets.only(left: 20,),
                                child: Text("posted on: "+DateFormat.Md().add_jm().format(time)),
                              )
                            ],
                          ),
                        ],
                      ),

                    ),
                  );
                },);
            }
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        },
        backgroundColor: Colors.blueAccent,

      ),
    );
  }
}
