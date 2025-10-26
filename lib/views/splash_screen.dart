// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../widgets/gradient_background.dart';
// import 'home_page.dart';
// import 'login_page.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   static const String name = 'splash-screen';
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushNamed(context, LoginScreen.name);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//           Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withAlpha(38),
//                 spreadRadius: 10,
//                 blurRadius: 10,
//                 offset: const Offset(4, 4),
//               ),
//             ],
//           ),
//           child: const Icon(Icons.school_outlined, color: Color(0xFF7F00FF), size: 60,),
//         ),
//
//               const SizedBox(height: 20),
//
//               const Text("SkillWave",
//                 style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,),),
//               const SizedBox(height: 10),
//
//               const Text("Your Learning Journey Begins",
//                 style: TextStyle(color: Colors.white70, fontSize: 14,),),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }


  void _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    final user = _auth.currentUser;
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomePage.name);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(38),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.school_outlined, color: Color(0xFF7F00FF), size: 60,),
              ),

              const SizedBox(height: 20),
              const Text("SkillWave", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10),
              const Text("Your Learning Journey Begins", style: TextStyle(color: Colors.white70, fontSize: 14,),),
            ],
          ),
        ),
      ),
    );
  }
}


