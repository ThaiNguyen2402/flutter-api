import 'package:app_api/app/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_api/app/model/product.dart'; // Import your product model
import 'package:app_api/app/data/sqlite.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false; // Example state for favorite button
  bool showFullDescription = false; // Track if full description should be shown
  int selectedSize = 38; // Default shoe size
  int quantity = 1; // Default quantity

  final DatabaseHelper _databaseService = DatabaseHelper(); // SQLite database helper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300, // Adjust size as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black, width: 1.0), // Stroke border
                  image: widget.product.imageUrl != null && widget.product.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(widget.product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.product.imageUrl == null || widget.product.imageUrl!.isEmpty
                    ? const Icon(Icons.image, size: 100)
                    : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        // Handle favorite action
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  NumberFormat('#,###.###đ').format(widget.product.price),
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  showFullDescription
                      ? widget.product.description // Display full product description
                      : (widget.product.description.length > 50
                          ? '${widget.product.description.substring(0, 100)}...' // Display truncated description
                          : widget.product.description), // Display full or truncated description
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              if (widget.product.description.length > 100)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showFullDescription = !showFullDescription;
                    });
                  },
                  child: Text(
                    showFullDescription ? 'Thu gọn' : 'Xem thêm',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: selectedSize,
                    items: [38, 39, 40, 41, 42].map((int size) {
                      return DropdownMenuItem<int>(
                        value: size,
                        child: Text('Size $size'),
                      );
                    }).toList(),
                    onChanged: (int? newSize) {
                      setState(() {
                        selectedSize = newSize!;
                      });
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _onSave(widget.product); // Handle buy now action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave(ProductModel pro) async {
    // You can still add the product to the cart without saving size and quantity to the database
    await _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1, // Keeping the default count as 1
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm sản phẩm vào giỏ hàng'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
