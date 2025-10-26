import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const String name = "Registration-page";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController _emailTEcontroller = TextEditingController();
  final TextEditingController _firstNameTEcontroller = TextEditingController();
  final TextEditingController _lastNameTEcontroller = TextEditingController();
  final TextEditingController _phoneTEcontroller = TextEditingController();
  final TextEditingController _passwordTEcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 60,),
              ),
              const SizedBox(height: 20),
              const Text("SkillWave", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 5),
              const Text("Start Your Learning Journey", style: TextStyle(color: Colors.white70, fontSize: 14,),),
              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      Text("Registration",
                        textAlign: TextAlign.center,
                        style:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),

                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstNameTEcontroller,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(hintText: "First Name",),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameTEcontroller,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(hintText: "Last Name",),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 2 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneTEcontroller,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(hintText: "Phone Number",),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.length < 3) {
                            return 'Name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailTEcontroller,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(hintText: "your@email.com",),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',);
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordTEcontroller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(hintText: "Password",),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one digit';
                          }
                          if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Login Button
                      Visibility(
                        visible: _isLoading == false,
                        replacement: CenteredCirculatProgressIncator(),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF7F00FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Sign-Up" , style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Unlock your potential with world-class courses",
                style: TextStyle(color: Colors.white70, fontSize: 13,),),
              const SizedBox(height: 30),
              RichText(text: TextSpan(
                  text: "Have an account? ",
                  style: TextStyle(color: Colors.white70, fontSize: 13,),
                  children: [
                    TextSpan(
                        text: "Sign-In",
                        style: TextStyle(fontWeight: FontWeight.w600,color: Colors.green ),
                        recognizer: TapGestureRecognizer()..onTap = _signIn
                    )
                  ]
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn(){Navigator.pop(context);}

  CenteredCirculatProgressIncator(){return Center(child: CircularProgressIndicator());}

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {_isLoading = true;});

      try {
        final fullName = "${_firstNameTEcontroller.text.trim()} ${_lastNameTEcontroller.text.trim()}";

        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailTEcontroller.text.trim(),
          password: _passwordTEcontroller.text.trim(),
        );

        final user = credential.user;
        await user!.updateDisplayName(fullName);
        await user.reload();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'firstName': _firstNameTEcontroller.text.trim(),
          'lastName': _lastNameTEcontroller.text.trim(),
          'email': _emailTEcontroller.text.trim(),
          'phone': _phoneTEcontroller.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.name, (predicate)=> false);
        }
      } on FirebaseAuthException catch (e) {
        String message = "Registration failed";

        if (e.code == 'email-already-in-use') {
          message = "This email is already registered.";
        } else if (e.code == 'weak-password') {
          message = "Password is too weak.";
        } else if (e.code == 'invalid-email') {
          message = "Invalid email format.";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      } finally {
        if (mounted) {setState(() {_isLoading = false;});}
      }
    }
  }



  @override
  void dispose() {
    _firstNameTEcontroller.dispose();
    _lastNameTEcontroller.dispose();
    _phoneTEcontroller.dispose();
    _emailTEcontroller.dispose();
    _passwordTEcontroller.dispose();
    super.dispose();
  }
}
