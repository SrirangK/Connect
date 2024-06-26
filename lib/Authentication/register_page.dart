import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/APIS/apis.dart';
import 'package:connect/functions/Textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({Key? key, this.onTap,  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
  final usernamecontroller=TextEditingController();
  final interestcontroller=TextEditingController();
  final statuscontroller=TextEditingController();

  final user=FirebaseAuth.instance.currentUser;

  Future<void> signuserUp() async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //create user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      // await addUserDetails(usernamecontroller.text, interestcontroller.text, statuscontroller.text, emailcontroller.text);
      await API.createUser(usernamecontroller.text, emailcontroller.text, interestcontroller.text, statuscontroller.text);


    }on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        Navigator.pop(context);
        wronglmessage();
      }
      else if(e.code=='wrong-password'){
        Navigator.pop(context);
        wronglmessage();
      }
    }


    Navigator.pop(context);
  }
  void wronglmessage(){
    showDialog(
        context:context,
        builder:(context){
          return const AlertDialog(title: Text('Ivalid email or password'),);
        }
    );
  }

  // Future addUserDetails(String username,String interest,String status,String useremail) async {
  //   await FirebaseFirestore.instance.collection('Users').add({
  //     'username':username,
  //     'interest':interest,
  //     'status':status,
  //     'email':useremail,
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child:Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    MyTextfield(controller: emailcontroller,hinttext: 'xyz@gmail.com',obscuretext: false,labelTexT: 'Email',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: passwordcontroller,hinttext: 'Password',obscuretext: true,labelTexT: 'Password',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: usernamecontroller,hinttext: 'XYZ',obscuretext: false,labelTexT: 'username',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: interestcontroller,hinttext: 'Interests',obscuretext: false,labelTexT: 'interests',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: statuscontroller,hinttext: 'Status',obscuretext: false,labelTexT: 'status',),

                    const SizedBox(height: 25,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: (){
                          signuserUp();
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>() ));
                        },
                        child: Text('SignUp',style: TextStyle(color: Colors.white,fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:50 ,),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black38,)),
                        Text('Or Continue With'),
                        Expanded(child: Divider(color: Colors.black38,))
                      ],
                    ),
                    const SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        const SizedBox(width: 4,),
                        GestureDetector(
                            onTap:widget.onTap,
                            child: Text('Login',
                              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )

    );
  }
}
