import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_app/UI/Screens/account_information.dart';
import 'package:manga_app/UI/Screens/change_password.dart';
import 'package:manga_app/UI/Screens/setting.dart';
import 'package:manga_app/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<String?> usernameData;
  String username = '';
  String? imageUrl;
  String? selectedImage;
  int selectedIndex = -1;

  List<String> icon = [
    "assets/img/icon1m.jpg",
    "assets/img/icon2m.jpg",
    "assets/img/icon3m.jpg",
    "assets/img/icon4m.jpg",
    "assets/img/icon1f.jpg",
    "assets/img/icon2f.jpg",
    "assets/img/icon3f.jpg",
    "assets/img/iconf4.jpg"
  ];
  
  @override
  void initState() {
    super.initState();
    loadUsername();
    loadIcon();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> fetchIcon() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
    if(snapshot.exists) {
      return snapshot.data()?['iconUrl'];
    }
    return null;
  }

  void loadIcon() async {
    final icon = await fetchIcon();
    setState(() {
      imageUrl = icon ?? "";
    });
  }

  Future<void> updateIcon() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'iconUrl': selectedImage});
  }

  Future<String?> fetchUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

    if(snapshot.exists) {
      return snapshot.data()?['username'];
    }
    return null;
  }

  void loadUsername() async {
    final name = await fetchUsername();
    setState(() {
      username = name ?? '';
    });
  }

  void logout() async {
    await authService.value.signOut();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        _buildUITitleandAvatar(),
        const SizedBox(height: 10),
        _buildUIsetting()
      ],
    ),
  );
}

Widget _buildUITitleandAvatar() {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: const Text(
              "Tài khoản",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setStateBuilder) {
                      return AlertDialog(
                        title: const Text("Đổi icon"),
                        content: SizedBox(
                          height: 300,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10
                            ), 
                            itemCount: icon.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setStateBuilder(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.amber : Colors.transparent
                                  ),
                                  child: Image.asset(
                                    icon[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                         actions: [
                          TextButton(
                            onPressed: () {
                              if(selectedIndex == -1) return;
                              setState(() {
                                selectedImage = icon[selectedIndex];
                                updateIcon();
                                imageUrl = selectedImage;
                                Navigator.pop(context);
                              });
                            }, 
                            child: const Text("Xác nhận")
                          )
                        ],
                      );
                    }
                  );
                }
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 60,
              backgroundImage: (imageUrl == null)
                ? AssetImage("assets/img/icon.png")
                : AssetImage(imageUrl!)
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 90),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Xin chào $username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    )),
                ),
                  Icon(Icons.waving_hand, color: Colors.yellow, size: 20),
                ],
              ),
            )
          ],
        );
      }

      Widget _buildUIsetting() {
        return Container(
          height: 260,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
          child: ListView(
            children: ListTile.divideTiles( context: context, tiles: [
                ListTile(
                  onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AccountInformation())),
                  leading: Icon(Icons.info),
                  title: Text('Thông tin tài khoản'),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChangePassword())),
                  leading: Icon(Icons.password),
                  title: Text('Đổi mật khẩu'),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ListTile(
                onTap: () {
                  showDialog<String>(
                    context: context, 
                    builder: (BuildContext content) => AlertDialog(
                      title: const Text("Cảnh báo"),
                      content: const Text("Bạn có muốn đăng xuất không"),
                      actions: <Widget> [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            logout();
                            Navigator.pop(context);
                          }, 
                          child: const Text('Ok')
                        )
                      ],
                    )
                  );
                },
                leading: Icon(Icons.logout),
                title: Text('Đăng xuất'),
                trailing: Icon(Icons.arrow_forward),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
                },
                title: const Text("Cài đặt"),
                trailing: const Icon(Icons.arrow_forward),
              )
            ]
          ).toList()
        )
      );
    }
  }