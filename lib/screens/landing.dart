import 'package:flutter/material.dart';
import 'animation.dart';
import 'login.dart';
import 'signup.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  List logoList = ['S', 'h', 'a', 'd', 'e', 'r'];
  TabController? tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 50,
              child: SizedBox(
                width: size.width,
                height: size.height * .2,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: logoList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return FadeY(
                        delay: index.toDouble() / 2,
                        child: Text(
                          logoList[index],
                          style: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 70, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LogIn(pageController: pageController),
                SignUp(pageController: pageController),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
