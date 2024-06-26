import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/functions/Textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({Key? key, this.onTap,  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller=TextEditingController();

  final passwordcontroller=TextEditingController();

  Future<void> signuserin() async {
    showDialog(
        context: context,
        builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      Navigator.pop(context);


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
    // Navigator.pop(context);
  }
  void wronglmessage(){
    showDialog(
      context:context,
        builder:(context){
          return const AlertDialog(title: Text('Ivalid email or password'),);
        }
     );
  }
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
                  const SizedBox(height: 7,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password? '),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: (){
                          signuserin();
                        },
                        child: Text('SignIn',style: TextStyle(color: Colors.white,fontSize: 20),),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?'),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap:widget.onTap,
                          child: Text('Register now',
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
