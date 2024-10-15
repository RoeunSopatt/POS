import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/model/product.dart';
import 'package:mobile/page/product/crud/createproduct.dart';
import 'package:mobile/page/product/view/viewdetail.dart';
import 'package:mobile/page/producttype/crud/createtype.dart';
import 'package:mobile/page/producttype/type.dart';
import 'package:mobile/services/service_controller.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController; // Nullable TabController

  @override
  void initState() {
    super.initState();

    // Initialize the TabController immediately
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Only dispose of the TabController if it was initialized
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0C7EA5),
          labelColor: const Color(0xFF0C7EA5),
          tabs: const [
            Tab(
              text: 'ទាំងអស់',
            ),
            Tab(
              text: 'ប្រភេទ',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProductView(),
          ProductType(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C7EA5),
        onPressed: () {
          if (_tabController!.index == 0) {
            Get.to(
              () => const CreateProduct(),
              transition: Transition.downToUp,
            );
          } else {
            Get.to(() => const CreateTypeProduct(),
                transition: Transition.downToUp,
                duration: const Duration(milliseconds: 350));
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView>
    with SingleTickerProviderStateMixin {
  late Future<Product> productsFuture;
  TabController? tabController; // Make TabController nullable
  List<ProductData> products = [];
  bool isLoading = true;
  String selectedTab = 'All'; // Default to 'All' category

  @override
  void initState() {
    super.initState();
    productsFuture = ServiceController.fetchProducts();
    productsFuture.then((productData) {
      if (mounted) {
        setState(() {
          products = productData.data ?? [];
          initializeTabController(); // Initialize the tabController here
          isLoading = false;
        });
      }
    });
  }

  // A separate function to initialize TabController
  void initializeTabController() {
    final productTypes = products
        .map((product) => product.type?.name)
        .toSet()
        .where((type) => type != null)
        .toList();

    productTypes.insert(0, 'All'); // Add 'All' tab
    tabController = TabController(length: productTypes.length, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose(); // Safely dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return UI.spinKit(); // Show loading spinner while fetching data
    } else {
      return buildContent(products); // Build the UI with the product data
    }
  }

  Widget buildContent(List<ProductData> products) {
    final productTypes = products.map((e) => e.type?.name).toSet().toList();
    productTypes.insert(0, 'All'); // Insert 'All' tab at the start

    // Select the first tab ('All') by default
    selectedTab =
        selectedTab.isEmpty && productTypes.isNotEmpty ? 'All' : selectedTab;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  onTap: (index) {
                    setState(() {
                      selectedTab = productTypes[index] ?? '';
                    });
                  },
                  tabs: productTypes.map((type) {
                    bool isSelected = selectedTab == type;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 6),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: const Color(0xFF0C7EA5),
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                          child: Text(
                            type!,
                            style: GoogleFonts.kantumruyPro(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  indicatorColor: Colors.transparent,
                  labelPadding: const EdgeInsets.all(0),
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  dividerHeight: 0,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: productTypes.map((productType) {
                final filteredProducts = productType == 'All'
                    ? products
                    : products
                        .where((product) => product.type?.name == productType)
                        .toList();

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return SwipeableActionCard(
                      product: product,
                      onDelete: () {
                        setState(() {
                          products.removeWhere((p) => p.id == product.id);
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeableActionCard extends StatefulWidget {
  final ProductData product;
  final Function onDelete;

  const SwipeableActionCard(
      {Key? key, required this.product, required this.onDelete})
      : super(key: key);

  @override
  _SwipeableActionCardState createState() => _SwipeableActionCardState();
}

class _SwipeableActionCardState extends State<SwipeableActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void deleteProduct() async {
    final ServiceController service = ServiceController();

    try {
      await service.deleteProduct(widget.product.id!);
      widget.onDelete();
      UI.toast(text: 'ប្រតិបត្តការជោគជ័យ');
    } catch (error) {
      print("Failed to delete product: $error");
      UI.toast(text: 'Error deleting product');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() =>
      _controller.isDismissed ? _controller.forward() : _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onHorizontalDragUpdate: (details) {
      if (details.primaryDelta! < -5) {
        _controller.forward();
      } else if (details.primaryDelta! > 10) {
        _controller.reverse();
      }
    },
    onTap: toggle,
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
               // Ensure this height matches the ListTile height
                decoration: const BoxDecoration(color:Color(0xFFFF0001)),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () {
                    deleteProduct();
                    _controller.reverse();
                  },
                ),
              ),
            ],
          ),
        ),
        SlideTransition(
          position:
              Tween<Offset>(begin: Offset.zero, end: const Offset(-0.2, 0))
                  .animate(_animation),
          child: InkWell(
            onTap: () {
              Get.to(
                () => ViewDetailProduct(
                  id: widget.product.id!,
                  images: widget.product.image!,
                  name: widget.product.name!,
                  price: widget.product.unitPrice!,
                  type: widget.product.type!.name!,
                  code: widget.product.code!,
                  date: widget.product.createdAt!,
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 350),
              );
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  // height: 80,  // Set the same height here
                   decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade100, // Apply the color you need
                        width: 1, // Adjust the thickness of the border
                      ),
                    ),
                  ),

                  
                  child: ListTile(
                    leading: Image.network(
                      widget.product.image ?? '',
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsHXrNDG5sDJWiLkS9g0GL7c_MPiFumwwFPhv9uNRu4eULdJJIQQtaPqfQt3o7QbRCTfE&usqp=CAU',
                        );
                      },
                      width: 60,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.product.type!.name} | ${widget.product.code}",
                          style: GoogleFonts.kantumruyPro(fontSize: 12),
                        ),
                        Text(
                          widget.product.name ?? 'Unknown Product',
                          style: GoogleFonts.kantumruyPro(),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${widget.product.unitPrice ?? 'N/A'}៛',
                      style: GoogleFonts.kantumruyPro(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }
}
