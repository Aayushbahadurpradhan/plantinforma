import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:plantinforma/screens/auth/forget_password_screen.dart';
import 'package:plantinforma/screens/auth/login_screen.dart';
import 'package:plantinforma/screens/auth/register_screen.dart';
import 'package:plantinforma/screens/auth/splash_screen.dart';
import 'package:plantinforma/screens/category/single_category_screen.dart';
import 'package:plantinforma/screens/dashboard/dashboard.dart';
import 'package:plantinforma/screens/home/dashboard.dart';
import 'package:plantinforma/screens/product/add_product_screen.dart';
import 'package:plantinforma/screens/product/edit_product_screen.dart';
import 'package:plantinforma/screens/product/my_product_screen.dart';
import 'package:plantinforma/screens/product/single_product_screen.dart';
import 'package:plantinforma/viewmodels/authe_viewmodel.dart';
import 'package:plantinforma/viewmodels/category_viewmodel.dart';
import 'package:plantinforma/viewmodels/global_ui_viewmodel.dart';
import 'package:plantinforma/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDK-BrzJXTKVGpJ-oqfSw_Y1D9XHDFJeMc",
      appId: "1:776790910496:android:6f282951cca2ba5fdbbe45",
      messagingSenderId: "776790910496",
      projectId: "plantinforma",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider (create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider (create: (_) => AuthViewModel()),
        ChangeNotifierProvider (create: (_) => CategoryViewModel()),
        ChangeNotifierProvider (create: (_) => PlantViewModel()),
      ],
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Image.asset("assets/images/loader.gif", height: 100, width: 100,),
        ),
        child: Consumer<GlobalUIViewModel>(
            builder: (context, loader, child) {
              if(loader.isLoading){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                initialRoute: "/login",
                routes: {
                  "/login": (BuildContext context)=>LoginScreen(),
                  "/splash": (BuildContext context)=>SplashScreen(),
                  "/register": (BuildContext context)=>RegisterScreen(),
                  "/forget-password": (BuildContext context)=>ForgetPasswordScreen(),
                  "/dashboard": (BuildContext context)=>DashboardScreen(),
                  "/add-product": (BuildContext context)=>AddProductScreen(),
                  "/edit-product": (BuildContext context)=>EditProductScreen(),
                  "/single-product": (BuildContext context)=>SingleProductScreen(),
                  "/single-category": (BuildContext context)=>SingleCategoryScreen(),
                  "/my-plants": (BuildContext context)=>MyProductScreen(),
                },
              );
            }
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
