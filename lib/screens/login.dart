import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/util.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/screens/animation.dart';

class LogIn extends StatefulWidget {
  final PageController pageController;

  const LogIn({Key? key, required this.pageController}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? _cCode, _phone, errorMSG;

  Future signInWithPhone({String? phone, cCode}) async {
    loading = false;
    String? _token, errorMsg;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      phoneNumber: '$cCode$phone',
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        var result = await auth.signInWithCredential(credential);
        if (result.user != null) {
          Navigator.pop(context);
        }
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          if (authException.code == 'invalid-phone-number') {
            errorMSG = lang(context, 'phoneNotCorrect');
          } else {
            errorMSG = lang(context, 'checkConnection');
          }
        });
      },
      codeSent: (String verificationCode, [int? forceResendToken]) {
        showModal(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              title: Center(
                  child: Text(
                lang(context, 'validation')!,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MyTextField(
                        size: const Size(300, 45),
                        onChanged: (val) {
                          _token = val;
                        },
                        textInputType: TextInputType.phone,
                        label: lang(context, 'validationKey'),
                        length: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          errorMsg ?? '',
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Button(
                            hasBorders: true,
                            title: lang(context, 'cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Button(
                            hasBorders: true,
                            title: lang(context, 'checkKey'),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              try {
                                AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: _token!);
                                var result = await auth.signInWithCredential(credential);
                                if (result.user != null) {
                                  Navigator.pop(context);
                                }
                              } catch (ex) {
                                setState(() {
                                  errorMsg = lang(context, 'ensureKey');
                                  loading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      loading == true
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (codeRetrieval) {
      },
    );
  }

  void login() async {
    final alreadyRegistered = await FB().alreadyRegistered(phone: _phone);
    if (alreadyRegistered == true) {
      setState(() {
        errorMSG = '';
      });
      signInWithPhone(phone: _phone, cCode: _cCode);
    } else {
      setState(() {
        errorMSG = lang(context, 'notRegistered');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: size.height * .24,
          child: FadeX(
            child: blurContainer(
              h: size.height * .55,
              w: size.width * .9,
              radius: 25,
            ),
          ),
        ),
        Positioned(
          top: size.height * .25,
          child: Text(
            errorMSG ?? '',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.greenAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: size.height * .4,
          left: size.width * .1,
          child: FadeX(
            child: MyCountryCode(
              onChanged: (code) {
                _cCode = code.dialCode;
              },
              onInit: (code) {
                _cCode = code.dialCode;
              },
            ),
          ),
        ),
        Positioned(
          top: size.height * .4,
          right: size.width * .1,
          child: SizedBox(
            width: size.width * .8 - 55,
            child: FadeX(
              child: MyTextField(
                size: size,
                label: lang(context, 'phone'),
                textInputType: TextInputType.emailAddress,
                onChanged: (phone) {
                  _phone = phone;
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height * .5,
          child: FadeX(
            child: Button(
              title: lang(context, 'login'),
              hasBorders: true,
              onPressed: () {
                login();
              },
            ),
          ),
        ),
        Positioned(
          top: size.height * .6,
          child: FadeX(
            child: Button(
              title: lang(context, 'newAcc'),
              hasBorders: false,
              onPressed: () {
                widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.ease);
              },
            ),
          ),
        ),
      ],
    );
  }
}
