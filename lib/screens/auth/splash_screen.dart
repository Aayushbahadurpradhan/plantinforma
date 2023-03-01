import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/authe_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthViewModel _authViewModel;

  void checkLogin() async{
    await Future.delayed(Duration(seconds: 5));
    if(_authViewModel.user==null){
      Navigator.of(context).pushReplacementNamed("/login");
    }else{
      Navigator.of(context).pushReplacementNamed("/dashboard");
    }
  }
  @override
  void initState() {
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    checkLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/plannt.gif"),
              SizedBox(height: 100,),
              Text("Plant Application", style: TextStyle(
                fontSize: 44
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
