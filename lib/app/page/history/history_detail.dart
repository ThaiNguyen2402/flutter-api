import 'package:app_api/app/model/bill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetail extends StatelessWidget {
  final List<BillDetailModel> bill;

  const HistoryDetail({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: ListView.builder(
        itemCount: bill.length,
        itemBuilder: (context, index) {
          var data = bill[index];
          var formattedPrice = NumberFormat('#,###.###đ').format(data.price);
          var formattedTotal = NumberFormat('#,###.###đ').format(data.total);

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sản phẩm: ${data.productName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Giá tiền 1 sản phẩm: $formattedPrice',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Tổng giá: $formattedTotal',
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
