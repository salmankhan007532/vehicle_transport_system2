import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';



class NDrawer extends StatefulWidget {
  const NDrawer({Key? key}) : super(key: key);

  @override
  State<NDrawer> createState() => _NDrawerState();
}

class _NDrawerState extends State<NDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FlutterLogo(
                      size: 50,
                    ),
                    const SizedBox(height: 10,),
                    Text(FirebaseAuth.instance.currentUser!.email!, style: const TextStyle(color: Colors.white),),
                  ],
                ),
              )),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: const Text('Rate Us'),
            onTap: () {
              Navigator.of(context).pop();

              StoreRedirect.redirect();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () {
              Navigator.of(context).pop();
              Share.share('install the app https://play.google.com/store/apps/details?id=com.bucks.hostel_finder_noor_rehman', subject: 'Hostel Finder!');

              },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Help Us Improve'),
            onTap: () async {
              Navigator.of(context).pop();

              const uri =
                  'mailto:fyp.hostelfinder@gmail.com?subject=Hostel Finder&body=Hi';
              if (await canLaunch(uri)) {
              await launch(uri);
              } else {
              throw 'Could not launch $uri';
              }
            },
          ),
        ],
      ),
    );
  }
}
