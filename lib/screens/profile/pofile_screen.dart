import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect/APIS/apis.dart';
import 'package:connect/Authentication/LoginPage.dart';

import '../../../main.dart';
import '../../models/ChatUser.dart';
import '../../widgets/bottomnavbar.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

Future<void> _signOut (BuildContext context) async{
  await API.auth.signOut();
  Navigator.pop(context,
      MaterialPageRoute(builder: (_) =>  LoginPage()));
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _formKey=GlobalKey<FormState>();
  String? _image;
  // String dropdownValue ='Dog' ;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      //for hiding keyboard
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: WillPopScope(                     //Going back to home screen
        onWillPop: (){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => BottomNavBar()));
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: const Text('Profile',style: TextStyle(color: Colors.white),),
                centerTitle: true,
                backgroundColor: Colors.black,
                leading: IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.arrow_back,color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                actions:[
                  IconButton(
                    onPressed: () {
                     _signOut(context);
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (_) =>  LoginPage()));
                  },
                      icon: const Icon(Icons.logout,color: Colors.white,)
                  )
                ]),

            body: Form(                       //To make fields necessary to fill
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
                child: SingleChildScrollView(
                  child: Column(children:[
                    SizedBox(width: mq.width,height: mq.height*0.03),
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                        // Local image
                            ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Background color
                            borderRadius: BorderRadius.circular(mq.height),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height),
                            child: Image.file(
                              File(_image!),
                              width: mq.height * 0.2,
                              height: mq.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        // Image from server
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(mq.height),
                              child: CachedNetworkImage(
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while loading
                                errorWidget: (context, url, error) =>  CircleAvatar(
                                  radius: 40, // Adjust radius if needed
                                  backgroundColor: Colors.grey.withOpacity(0.3), // Ensure background is transparent inside the circle
                                  child: Icon(Icons.person, size: 40), // Adjust icon size if needed
                                ),
                              ),
                            ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 5,
                            onPressed: (){
                              _showBottomSheet();
                            },
                            color:Colors.white,
                            shape: const CircleBorder(),
                            child:const Icon(Icons.edit,color: Colors.blue,),),
                        )
                      ],
                    ),

                    //for adding some space
                    SizedBox(height: mq.height*0.03),
                    Text(widget.user.email,style: const TextStyle(color:Colors.black38,fontSize: 16),),
                    //for adding some space
                    SizedBox(height: mq.height*0.05),

                    TextFormField(
                        onSaved: (val)=>API.me.username=val ??'',
                        validator: (val)=> val != null && val.isNotEmpty ?null :'Name Required',
                        initialValue: widget.user.username,
                        decoration: InputDecoration(
                            prefixIcon:const Icon(Icons.person,color: Colors.blue,),
                            border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            label: const Text('Name')
                        )
                    ),
                    SizedBox(height: mq.height*0.02),

                    TextFormField(
                        initialValue: widget.user.status,
                        onSaved: (val)=>API.me.status=val ??'',
                        decoration: InputDecoration(
                            prefixIcon:const Icon(Icons.info_outline,color: Colors.blue,),
                            border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            label: const Text('Status')
                        )
                    ),

                    SizedBox(height: mq.height*0.03),

                    TextFormField(
                        initialValue: widget.user.interest,
                        onSaved: (val)=>API.me.interest=val ??'',
                        validator: (val)=> val != null && val.isNotEmpty ?null :'Please provide your interests',
                        decoration: InputDecoration(
                            prefixIcon:const Icon(Icons.interests,color: Colors.blue,),
                            border:  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            label: const Text('interest')
                        )
                    ),
                    SizedBox(height: mq.height*0.05),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          await API.updateuserinfo();
                          // Navigator.pop(context);
                          // Dialogue.showsSnackbar(context, 'Updated');
                          //snackbar to show that profile is updated
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully!')),
                          );
                        }
                      },

                      icon:const Icon(Icons.edit),
                      label: const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ), // Text style
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                    )


                  ]),
                ),
              ),
            )
        ),
      ),
    );

  }

//Change profile picture
  void _showBottomSheet() {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),topRight: Radius.circular(40))),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height*0.03,bottom: mq.height*0.05),
            children: [
              const Text('Profile Picture',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,),
              SizedBox(height: mq.height*0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                        if (image!=null){
                          setState(() {
                            _image=image.path;
                          });
                          API.updateprofilepicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width*0.2, mq.height*0.1),
                          shape:const CircleBorder()
                      ),
                      child: Image.asset('images/gallery .png')),

                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if (image!=null){
                          setState(() {
                            _image=image.path;
                          });
                          API.updateprofilepicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width*0.2, mq.height*0.1),
                          shape:const CircleBorder()
                      ),
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
