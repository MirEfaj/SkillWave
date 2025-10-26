import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:skill_wave/views/registration_page.dart';
import '../widgets/gradient_background.dart';
import '../widgets/logo_screen.dart';
import 'forget_password_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = "login-page";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
              const SizedBox(height: 80),
              const LogoScreen(),
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
                    Text("Log-in",
                         textAlign: TextAlign.center,
                         style:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),

                      const SizedBox(height: 20),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
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
                        controller: _passwordController,
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
                        replacement: CenteredCirculatProgressIncator() ,
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:  _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF7F00FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Sign In" , style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
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
              const SizedBox(height: 10),
              RichText(text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.white70, fontSize: 13,),
                children: [
                  TextSpan(
                    text: "Sign-Up",
                    style: TextStyle(fontWeight: FontWeight.w600,color: Colors.green ),
                    recognizer: TapGestureRecognizer()..onTap =  _signUp
                  )
                ]
              )),
              const SizedBox(height: 20),
              TextButton(onPressed: _forgetPass, child: Text("Forget Password",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.green ),)),
            ],
          ),
        ),
      ),
    );
  }

   CenteredCirculatProgressIncator(){
    return Center(child: CircularProgressIndicator());
  }

 Future<void>  _signIn() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {_isLoading = true;});

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text
      );
      Navigator.pushNamedAndRemoveUntil(context, HomePage.name, (predicate)=> false);
    } on FirebaseAuthException catch (e){
      String message;
      switch(e.code){
        case "user-not-found" :
          message = "No user found for that email";
          break;
        case "wrong-password" :
          message = "incorrect password";
          break;
        case "invalid-email" :
          message = "invalid email formate";
          break;
        default :
          message = "login failed. Please try again";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch(_){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong, Try again Letter")));
    } finally{
      setState(() {_isLoading = false;});
    }
  }


  void _signUp() { {Navigator.pushNamed(context, RegistrationScreen.name);}}
  void _forgetPass(){Navigator.pushNamed(context, ForgetPasswordScreen.name);}


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}




