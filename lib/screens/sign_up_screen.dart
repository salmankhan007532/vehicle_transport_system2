import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_transport_system2/screens/vehical_list_screen.dart';
import 'package:vehicle_transport_system2/screens/login_screen.dart';
import 'package:vehicle_transport_system2/screens/map_screen.dart';
import 'package:vehicle_transport_system2/utils/constants.dart';
import 'package:vehicle_transport_system2/utils/network_connection.dart';

class SignUpScreen extends StatefulWidget {

  final String userType;

  const SignUpScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Container(
        height: double.infinity,
            width: double.infinity,
            decoration:  const BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Constants.bluecolor1, Constants.bluecolor2],
            ),
            ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'Enter Email',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async{
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
        
                      if (email.isEmpty) {
                        Fluttertoast.showToast(msg: 'Please provide Email');
                        return;
                      }
        
                      if (password.isEmpty) {
                        Fluttertoast.showToast(msg: 'Please provide password');
                        return;
                      }
        
                      if (password.length < 6) {
                        Fluttertoast.showToast(
                            msg:
                            'Weak Password, at least 6 characters are required');
        
                        return;
                      }
        
                      if( await NetworkConnection.isNotConnected()){
                        Fluttertoast.showToast(msg: 'You are Offline\nConnect to Internet and try again');
                        return;
                      }
        
                      if( !EmailValidator.validate(email)){
                        Fluttertoast.showToast(msg: 'Invalid Email Address', backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
                        return;
                      }
                      // sign up using firebase auth
        
                      ProgressDialog progressDialog = ProgressDialog(
                        context,
                        title: const  Text('Signing Up'),
                        message: const Text('Please wait'),
                      );
        
                      progressDialog.show();
                      try {
        
        
                        FirebaseAuth auth = FirebaseAuth.instance;
        
                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                            email: email, password: password);
        
                        if (userCredential.user != null) {
        
                          // store user information in Realtime database
        
                          DatabaseReference userRef = FirebaseDatabase.instance.ref().child( 'users');
        
                          String uid = userCredential.user!.uid;
                          int dt = DateTime.now().millisecondsSinceEpoch;
        
                          await userRef.child(uid).set({
                            'email': email,
                            'uid': uid,
                            'dt': dt,
                            'userType': widget.userType
        
                          });
        
        
                          Fluttertoast.showToast(msg: 'Success');
        
                          //Navigator.of(context).pop();
                          progressDialog.dismiss();
        
                          SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                          sharedPrefs.setString(Constants.userType, widget.userType);
        
        
                          if(widget.userType == Constants.vehicalOwner){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                              return const VehicalsListScreen();
                            }));
                          }else{
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                              return const MapScreen();
                            }));
                          }
        
                        } else {
                          Fluttertoast.showToast(msg: 'Failed');
                          progressDialog.dismiss();
        
                        }
        
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(msg: 'Email is already in Use');
                        } else if (e.code == 'weak-password') {
                          Fluttertoast.showToast(msg: 'Password is weak');
                        }
                      } catch (e) {
                        progressDialog.dismiss();
                        Fluttertoast.showToast(msg: 'Something went wrong');
                      }
        
        
                    },
                    child: const Text('Create Account')),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return LoginScreen(userType: widget.userType);
                              }));
                        },
                        child: const Text(' Login now'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
