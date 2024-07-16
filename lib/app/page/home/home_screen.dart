import 'dart:io';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/page/home/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  late Set<int> favoriteProductIds;
  late List<ProductModel> allProducts;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    favoriteProductIds = Set<int>(); // Initialize empty set
    allProducts = [];
    selectedCategory = null; // Initially no category selected
  }

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  Future<List<CategoryModel>> _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(Cart(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm sản phẩm vào giỏ hàng'),
        duration: Duration(seconds: 1),
      ),
    );
    setState(() {});
  }

  void _toggleFavorite(int productId) {
    setState(() {
      if (favoriteProductIds.contains(productId)) {
        favoriteProductIds.remove(productId);
      } else {
        favoriteProductIds.add(productId);
      }
    });
  }

  void _selectCategory(CategoryModel category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = null; // Deselect category if already selected
      } else {
        selectedCategory = category; // Select the category
      }
    });
  }

  void _showAllProducts() {
    setState(() {
      selectedCategory = null; // Show all products (deselect category)
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: _getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Text(
                    "Xin chào, bạn đã trở lại Fein Store!",
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Dành cho bạn",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          _selectCategory(category);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Bo tròn góc
                                  color: Colors.grey[200], 
                                  border: Border.all(color: Colors.black, width: 1.0),// Background color
                                ),
                                width: 120, // Adjust size as needed
                                height: 120, // Adjust size as needed
                                child: ClipOval(
                                  child: Image.network(
                                    category.imageUrl, // URL của ảnh category
                                    fit: BoxFit.cover,
                                    width: 90, // Adjust size as needed
                                    height: 90, // Adjust size as needed
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0), // Adjust spacing as needed
                GestureDetector(
                  onTap: () {
                    _showAllProducts(); // Show all products when tapped
                  },
                  child: Row(
                    children: [
                      Text(
                        "Tất cả sản phẩm",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                FutureBuilder<List<ProductModel>>(
                  future: _getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Filter products by selected category
                    List<ProductModel> filteredProducts = snapshot.data!;
                    if (selectedCategory != null) {
                      filteredProducts = filteredProducts.where((product) =>
                          product.categoryId == selectedCategory!.id).toList();
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final itemProduct = filteredProducts[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(product: itemProduct),
                              ),
                            );
                          },
                          child: _buildProduct(itemProduct, context),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    bool isFavorite = favoriteProductIds.contains(pro.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align the content
        children: [
          Container(
            width: 150, // Fixed width for the image
            height: 120, // Fixed height for the image
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0), // Stroke border
              borderRadius: BorderRadius.circular(8.0),
              image: pro.imageUrl != null && pro.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(pro.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: pro.imageUrl == null || pro.imageUrl.isEmpty
                ? const Icon(Icons.image, size: 50)
                : null,
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              pro.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: Text(
              NumberFormat('#,###.###đ').format(pro.price),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    _onSave(pro);
                  },
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _toggleFavorite(pro.id);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
