import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentors/bloc/ProductDetailsBloc.dart';
import 'package:rentors/generated/l10n.dart';
import 'package:rentors/screen/booking/MyBookingScreen.dart';
import 'package:rentors/screen/booking/MyProductBookingScreen.dart';
import 'package:rentors/widget/CenterHorizontal.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BookingScreenState();
  }
}

class BookingScreenState extends State<BookingScreen> {
  var mBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mBloc = ProductDetailsBloc();
  }

  Widget tabWiget() {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                labelColor: Theme.of(context).backgroundColor,
                tabs: [
                  Tab(
                    text: S.of(context).bookingPlaced,
                  ),
                  Tab(text: S.of(context).bookingReceived),
                ],
                indicatorWeight: 4.0),
            title: Text(
              S.of(context).booking,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: TabBarView(
            children: [
              MyBookingScreen(),
              MyProductBookingScreen(),
            ],
          ),
        ));
  }

  // Widget progressIndicatorView() {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("sdfsdf")
  //         //Text(S.of(context).booking),
  //         ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [CenterHorizontal(CircularProgressIndicator())],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return tabWiget();
  }
}

// AppBar(
//         brightness: Brightness.dark,
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         title: Image.asset(
//           'assets/img/splash/logo.png',
//           fit: BoxFit.fitHeight,
//           height: 40,
//         ),
//         // Text(
//         //   S.of(context).rentHire,
//         //   style: TextStyle(color: Colors.white),
//         // ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
