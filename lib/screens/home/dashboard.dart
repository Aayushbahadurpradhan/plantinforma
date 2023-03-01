// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/authe_viewmodel.dart';
// import '../../viewmodels/global_ui_viewmodel.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);
//
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   void logout() async {
//     _ui.loadState(true);
//     try {
//       await _auth.logout().then((value) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       }).catchError((e) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.message.toString())));
//       });
//     } catch (err) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(err.toString())));
//     }
//     _ui.loadState(false);
//   }
//
//   late GlobalUIViewModel _ui;
//   late AuthViewModel _auth;
//   @override
//   void initState() {
//     _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
//     _auth = Provider.of<AuthViewModel>(context, listen: false);
//     super.initState();
//   }
//
//   Widget _searchBar() {
//     return Container(
//       height: 50,
//       width: 350,
//       child: Material(
//         elevation: 1,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextFormField(
//           decoration: InputDecoration(
//             hintText: "Search Something",
//             prefixIcon: Icon(
//               Icons.search,
//               size: 26,
//             ),
//             fillColor: Color(0xffe4e4e4),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _hotel({
//     required String image,
//     required String tittle,
//     // required String subtittle,
//     // required String time,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 160,
//             width: 310,
//             decoration: BoxDecoration(
//                 color: Colors.grey,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(image),
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 )),
//           ),
//           Container(
//             height: 80,
//             width: 310,
//             decoration: BoxDecoration(
//                 color: Color(0xfff1f1f1),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 )),
//             child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     tittle,
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.watch_later_outlined,
//                         color: Color(0xffdf842b),
//                         size: 20,
//                       ),
//                       Container(
//                         width: 260,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Text(
//                             //   ' $time',
//                             //   style: TextStyle(
//                             //     fontSize: 20,
//                             //     fontWeight: FontWeight.bold,
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _category({
//     required String image,
//     required String catename,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 70,
//             width: 70,
//             decoration: BoxDecoration(
//                 color: Colors.grey,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(image),
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 )),
//           ),
//           Text(
//             catename,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         child: ListView(
//           children: [
//             Container(
//               height: 80,
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 60,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Home",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _searchBar(),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               "Plants",
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _hotel(
//                     image: "assets/images/auta.jpg",
//                     tittle: "hawa",
//                   ),
//                   _hotel(
//                     image: "assets/images/auta.jpg",
//                     // time: "20 ~ 40 min",
//                     tittle: "hawa",
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               "Choose by Category",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 30,
//                   ),
//                   _category(
//                     image: "assets/home3.png",
//                     catename: "hora",
//                   ),
//                   _category(
//                     image: "assets/home4.png",
//                     catename: "haina",
//                   ),
//                   _category(
//                     image: "assets/home3.png",
//                     catename: "hora",
//                   ),
//                   _category(
//                     image: "assets/home4.png",
//                     catename: "haina",
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 30,
//                   ),
//                   _category(
//                     image: "assets/home3.png",
//                     catename: "hora",
//                   ),
//                   _category(
//                     image: "assets/home4.png",
//                     catename: "haina",
//                   ),
//                   _category(
//                     image: "assets/home3.png",
//                     catename: "hora",
//                   ),
//                   _category(
//                     image: "assets/home4.png",
//                     catename: "haina",
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
