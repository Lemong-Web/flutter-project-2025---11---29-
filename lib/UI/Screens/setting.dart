import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool mode = false;
  void deleteData() async {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for(var key in keys) {
        if (key.startsWith('last_read_index_') || key.startsWith('favorite_') || key.startsWith('history_')) {
          await prefs.remove(key);
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393D5E),
      appBar: AppBar(
         backgroundColor: Color(0xFF393D5E),
         foregroundColor: Colors.white,
         title: const Text(
          "Cài đặt",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          height: 120,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey
          ),
          child: ListView(
            children: [
              ListTile(
                leading: mode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                title: mode ? Text("Tối") : Text("Sáng"),
                trailing: Switch(
                  value: mode,
                  inactiveThumbColor: Colors.yellow,
                  inactiveTrackColor: Colors.amber,
                  onChanged: (bool value) {
                    setState(() {
                      mode = value;
                    });
                  } 
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog<String>(
                    context: context, 
                    builder: (BuildContext content) => AlertDialog(
                      title: const Text("Cảnh Báo"),
                      content: const Text("Điều này sẽ xóa danh sach yêu thích, lịch sử tìm kiếm, đánh dấu chương\nbạn có muốn xóa không? "),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, 
                          child: const Text("Hủy")),
                        TextButton(
                          onPressed: () {
                            deleteData();
                            final snackBar = SnackBar(
                            content: const Text("Dữ liệu đã được xóa"),
                            action: SnackBarAction(
                              label: "Ok", 
                              onPressed: () {}
                            ),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }, 
                          child: Text("Ok"))
                      ],
                    )
                  );
                },
                  leading: const Icon(Icons.folder_off),
                  title: const Text('Xóa dữ liệu'),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }