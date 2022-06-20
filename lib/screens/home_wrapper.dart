import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/screens/users/clinet/clients.dart';
import 'package:harvest/screens/users/commen/drawer.dart';
import 'package:harvest/screens/users/delivery/delivery.dart';
import 'package:harvest/screens/users/vendor/vendor.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';
import 'package:harvest/util/database.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> with SingleTickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  late AnimationController animationController;
  late Animation animation;
  bool _canBeDragged = false;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.ease);
    updateMyLocation();
    super.initState();
  }

  _toggleDrawer() => animationController.isDismissed ? animationController.forward() : animationController.reverse();

  _onDragStart(DragStartDetails details) {

    bool isDragCloseFromRight = animationController.isDismissed && details.globalPosition.dx > 50;
    bool isDragOpenFromLeft = animationController.isCompleted;
    _canBeDragged = isDragCloseFromRight || isDragOpenFromLeft;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / 180;
      animationController.value -= delta;
    }
  }

  _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() <= 360.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  updateMyLocation() async {
    FB(uid: user!.uid).updateMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<Users>(
        stream: FB(uid: user.uid).getAccType,
        builder: (context, snapshot) {
          return GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragEnd: _onDragEnd,
            onHorizontalDragUpdate: _onDragUpdate,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: AppBar(
                  backgroundColor: const Color(0xfff2b705),
                  title: const Text('Shader'),
                  centerTitle: true,
                  elevation: 0.0,
                  actions: [
                    IconButton(icon: const Icon(Icons.dehaze_rounded), onPressed: _toggleDrawer),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  const MainDrawer(),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate((animation.value * -size.width * .7), (animation.value * size.height * .025))
                          ..scale(1 - (animation.value * .1)),
                        child: IgnorePointer(
                          ignoring: animationController.isCompleted,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(animation.value * 30)),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, offset: const Offset(5, 0), blurRadius: 12, spreadRadius: animation.value * 6),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(animation.value * 30),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                    child: snapshot.hasData
                        ? snapshot.data!.accType == AccType.client.toString()
                            ? const Clients()
                            : snapshot.data!.accType == AccType.delivery.toString()
                                ? const Delivery()
                                : const Vendor()
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onHorizontalDragStart: _onDragStart,
                      onHorizontalDragEnd: _onDragEnd,
                      onHorizontalDragUpdate: _onDragUpdate,
                      child: Container(
                        width: 30,
                        height: size.height,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
