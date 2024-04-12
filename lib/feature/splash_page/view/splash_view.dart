import 'package:flutter/material.dart';
import 'package:reservation/core/constants/duration_items.dart';
import 'package:reservation/core/constants/image_const.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';
import 'package:reservation/feature/home_page/view/home_view.dart';
import 'package:reservation/feature/login_register_page/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showNavigation = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(DurationItems.durationNormal(), () {
      _navigateIfUserTypeSet();
    });
  }

  Future<void> _navigateIfUserTypeSet() async {
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userType = prefs.getString('userType');
    if (userType != null) {
      _navigateToScreen(userType);
    } else */
      setState(() {
        showNavigation = true;
      });

  }

  void _navigateToScreen(String userType) {
    if (userType == 'consumer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (userType == 'manager') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage(key: Key('register_page_key'),)),
      );
    }
  }

  Future<void> _setUserTypeAndNavigate(String userType) async {
    CommonUtils.log("Setting user type to $userType");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    _navigateToScreen(userType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           Center(
            
  child: Image.asset(
    'assets/image/DineIn.jpeg',
    // Adjust width and height as needed
    width: 200, // Example width
    height: 200, // Example height
  ),
),


          if (showNavigation)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _setUserTypeAndNavigate('consumer'),

                    child: const Text('Consumer',),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => _setUserTypeAndNavigate('manager'),
                    child: const Text('Manager'),
                  ),
                  SizedBox(
                    height: context.dynamicHeight(0.2),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
