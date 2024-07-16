import 'dart:convert';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/cart/cart_screen.dart';
import 'package:app_api/app/page/category/category_list.dart';
import 'package:app_api/app/page/detail.dart';
import 'package:app_api/app/page/history/history_screen.dart';
import 'package:app_api/app/page/home/home_screen.dart';
import 'package:app_api/app/page/product/product_list.dart';
import 'package:app_api/app/route/page3.dart';
import 'package:flutter/material.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() { });
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Trang chủ";
    switch (index) {
      case 0:
       {
        return HomeBuilder();
       }
      case 1:
        {
          return HistoryScreen();
        }
      case 2:
        {
          return CartScreen();
        }
      case 3:
        {
          return const Detail();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo1.png', // Đường dẫn đến hình ảnh logo
                fit: BoxFit.contain,
                height: 50, // Chiều cao của logo
              ),
            ],
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề trong AppBar
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 197, 193, 193),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.length < 5
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            user.imageURL!,
                          )),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(user.fullName!),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('Đơn hàng'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Giỏ hàng'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 2;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Category'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CategoryList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('Sản phẩm'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProductList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pages),
              title: const Text('Page'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Page3()));
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
