import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/bill.dart';
import 'package:app_api/app/page/history/history_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  Future<List<BillModel>> _getBills() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<BillModel> bills = await APIRepository().getHistory(prefs.getString('token').toString());

  // Sắp xếp danh sách theo ngày giảm dần
  bills.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

  return bills;
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BillModel>>(
      future: _getBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Không có lịch sử đơn hàng.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemBill = snapshot.data![index];
              return _billWidget(itemBill, context);
            },
          ),
        );
      },
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await APIRepository().getHistoryDetail(bill.id, prefs.getString('token').toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetail(bill: temp)));
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.black, width: 1.0), // Đổi màu và độ rộng viền tùy thích
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã đơn hàng: ' + bill.id.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Người nhận: ' + bill.fullName,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Tổng tiền: ' + NumberFormat('#,###.###đ').format(bill.total),
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Ngày thanh toán: ' + bill.dateCreated,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
