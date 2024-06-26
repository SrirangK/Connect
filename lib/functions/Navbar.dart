import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connect/APIS/apis.dart';
import 'package:connect/models/ChatUser.dart';
import '../screens/profile/pofile_screen.dart';

class Navbar extends StatefulWidget {
  final ChatUser user;
  Navbar({Key? key, required this.user, }) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _selfinfo();
  }
  Future<void> _selfinfo()async {
    await API.getselfinfo();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero  ,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("  "+widget.user.username,style: GoogleFonts.poppins(),),
              accountEmail: Text("  "+widget.user.email,style: GoogleFonts.poppins(),),
              currentAccountPicture: ClipRRect(
                  // radius: mq.width*0.02,
                borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    // width: mq.width*0.05,
                    // height: mq.height*0.05,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) =>const  CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person),),
                  ),
                ),
              
          ),
          ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Text('Profile'),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (_)=>  ProfileScreen(user: widget.user)
                  ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center_sharp),
            title: Text('Business'),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: (){
                FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
