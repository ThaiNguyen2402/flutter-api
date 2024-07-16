import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    // create style
    TextStyle mystyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: user.imageURL != null && user.imageURL!.isNotEmpty
                          ? Image.network(
                              user.imageURL!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              size: 200,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(height: 16.0),
                    Text("ID: ${user.idNumber}", style: mystyle),
                    const SizedBox(height: 8.0),
                    Text("Họ và tên: ${user.fullName}", style: mystyle),
                    const SizedBox(height: 8.0),
                    Text("Số điện thoại: ${user.phoneNumber}", style: mystyle),
                    const SizedBox(height: 8.0),
                    Text("Giới tính: ${user.gender}", style: mystyle),
                    const SizedBox(height: 8.0),
                    Text("Ngày sinh: ${user.birthDay}", style: mystyle),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
