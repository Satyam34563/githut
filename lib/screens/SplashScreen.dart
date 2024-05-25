import 'package:flutter/material.dart';

class SplashScrren extends StatefulWidget {
  const SplashScrren({super.key});
  static String routeName = 'SplashScreen';

  @override
  State<SplashScrren> createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
          context, "HomePage", (route) => false);
    });
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network("https://pngimg.com/uploads/github/github_PNG85.png", width: 200, height: 200,),
      ),
    );
  }
}
