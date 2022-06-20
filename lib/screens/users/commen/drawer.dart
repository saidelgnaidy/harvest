import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? _accountTypeSelected;
  AccType? _accType;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final User user = Provider.of<User>(context);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: StreamBuilder<Users>(
          stream: FB(uid: user.uid).userByUId,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Positioned(
                    top: 50,
                    right: 8,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/back0.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    right: 90,
                    child: Text(
                      snapshot.data!.name!,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 90,
                    child: Text(
                      snapshot.data!.phone!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 50,
                    width: size.width * .55,
                    height: 40,
                    child: ListTile(
                      trailing: Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        lang(context, 'signOut')!,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        FB().signOut();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 0,
                    width: size.width * .55,
                    child: ListTile(
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: SizedBox(
                        width: size.width * .55,
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              items: <String?>[
                                lang(context, 'client'),
                                lang(context, 'delivery'),
                                lang(context, 'farmer'),
                              ].map((String? accountType) {
                                return DropdownMenuItem<String>(
                                  value: accountType,
                                  child: Center(
                                    child: Text(
                                      accountType!,
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? accountType) {
                                _accountTypeSelected = accountType;
                                if (_accountTypeSelected == lang(context, 'client')) {
                                  _accType = AccType.client;
                                } else if (_accountTypeSelected == lang(context, 'delivery')) {
                                  _accType = AccType.delivery;
                                } else if (_accountTypeSelected == lang(context, 'farmer')) {
                                  _accType = AccType.vendor;
                                }
                                FB(uid: user.uid).updateAccType(_accType);
                              },
                              icon: const Icon(null),
                              hint: Center(
                                child: Text(
                                  snapshot.data!.accType == AccType.vendor.toString()
                                      ? lang(context, 'farmer')!
                                      : snapshot.data!.accType == AccType.client.toString()
                                          ? lang(context, 'client')!
                                          : lang(context, 'delivery')!,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              isExpanded: true,
                              autofocus: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary.withOpacity(.5)),
                ),
              );
            }
          }),
    );
  }
}
