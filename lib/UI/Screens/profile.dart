import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/account_setting.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393D5E),
      body: _buildUI(),
    );
  }
  
  Widget _buildUI() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.center,
          child: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Inter",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 100,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle
          ),
          child: Placeholder(),
        ),
        const SizedBox(height: 20),
        Container(
          width: 326,
          height: 110,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Color(0xffFFFFFF).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(right: 215, top: 20),
                child: Text(
                  "Account",
                  style: TextStyle(
                    color: Color(0xff04004F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xff04004F)
                ),
                title: const Text(
                  "Data",
                  style: TextStyle(
                    color: Color(0xff04004F)
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xff04004F),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        Container(
          width: 326,
          height: 94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            color: Color(0xffEDF7F8).withOpacity(0.3)
          ),
           child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 180, top: 10),
                child: const Text(
                  "Notification",
                  style: TextStyle(
                    color: Color(0xff04004F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ),
              ListTile(
                 leading: Icon(
                  Icons.notifications,
                  color: Color(0xff04004F)
                ),
                title: const Text(
                  "Pop-up Notification",
                  style: TextStyle(
                    color: Color(0xff04004F)
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xff04004F)
                ),
              )
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        Container(
          width: 326,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Color(0xffEDF7F8).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 240, top: 15),
                child: Text(
                  "Other",
                  style: TextStyle(
                    color: Color(0xff04004F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 19),
                dense: true,
                minVerticalPadding: 0,
                leading: Icon(
                  Icons.mail,
                  color: Color(0xff04004F),
                  size: 17
                ),
                title: Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Color(0xff04004F),
                    fontSize: 17
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xff04004F),
                  size: 17
                )
              ),
            
              ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 19),
                dense: true,
                minVerticalPadding: 5,
                leading: Icon (
                  Icons.shield,
                  color: Color(0xff04004F),
                  size: 17
                ),
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Color(0xff04004F),
                    fontSize: 17  
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xff04004F),
                  size: 17
                ) 
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSetting()));
                },
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 19),
                  dense: true,
                  minVerticalPadding: 5,
                  leading: Icon(
                    Icons.settings,
                    color: Color(0xff04004F),
                    size: 17,
                  ),
                  title: const Text(
                    "Settings",
                    style: TextStyle(
                      color: Color(0xff04004F),
                      fontSize: 17
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Color(0xff04004F),
                    size: 17
                  ) 
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}