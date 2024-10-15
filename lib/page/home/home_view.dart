import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile/component/peichart.dart';
import 'package:mobile/component/showbottomsheet.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/colors.dart';
import 'package:mobile/entity/model/cashier.dart';
import 'package:mobile/entity/model/dashboard.dart';
import 'package:mobile/entity/model/statisticproducttype.dart';
import 'package:mobile/entity/model/statisticsale.dart';
import 'package:mobile/extension/extension_method.dart';
import 'package:mobile/services/service_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Dashboard> futureDashboard;
  late Future<List<Cashier>> futureCashier;

  final ServiceController service = ServiceController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureDashboard = service.fetchDashboard();
    futureCashier = service.fetchCashier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Carousel Slider for both cards
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: false,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: [
                      // First card widget: Sales Card
                      SalesCardWidget(),
                      // Second card widget: Dashboard grid from API data
                      buildDashboardGrid(),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          2,
                          (index) =>
                              Indicator(isActive: _currentIndex == index)),
                    ),
                  ),
                ],
              ),
            ),
            // Indicator for the Carousel Slider

            const SizedBox(height: 10),

            // Other widgets below the carousel...
            CashierSection(),
            const SizedBox(height: 10),
            buildProductTypeStats(),
            const SizedBox(height: 10),
            buildSalesStats(),
          ],
        ),
      ),
    );
  }

  Widget buildSalesCard() {
    int? selectedIndex;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ការលក់', // Sales Title
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showCustomBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: calendar.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Image(
                                      height: 22,
                                      image: AssetImage(calendar[index]),
                                    ),
                                    title: Text(
                                      title[index],
                                      style: GoogleFonts.kantumruyPro(),
                                    ),
                                    trailing: selectedIndex == index
                                        ? const Icon(Icons.check,
                                            color: Colors
                                                .green) // Show check icon if selected
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex =
                                            index; // Update selected index
                                      });

                                      Navigator.pop(
                                          context); // Close the bottom sheet

                                      if (index == 5) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DateChooser(),
                                          ),
                                        );
                                      } else {
                                        print(
                                            'No page available for this index');
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Text("ថ្ងៃនេះ", style: TextStyle(fontSize: 12)),
                            SizedBox(width: 5),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sales Amount
                Text(
                  '60,998,900 ៛', // Total Sales
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                // Percentage Growth
                Row(
                  children: [
                    Text(
                      'កើនឡើង', // Increase Percentage
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' +15% (6,099,900)', // Increase Percentage
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ' ធៀបនឹងម្សិលមិញ', // Increase Percentage
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDashboardGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.white),
      child: FutureBuilder<Dashboard>(
        future: futureDashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return createDashboardGrid(snapshot.data!.statatics);
            } else if (snapshot.hasError) {
              return const Text("Error loading dashboard data");
            }
          }
          return UI.spinKit();
        },
      ),
    );
  }

  Widget createDashboardGrid(Statatics? statatics) {
    final counts = [
      '${statatics?.totalProduct ?? "0"}',
      '${statatics?.totalProductType ?? "0"}',
      '${statatics?.totalUser ?? "0"}',
      '${statatics?.totalOrder ?? "0"}',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 2.2,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: AssetImage(icons[index]),
                        height: 22,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            counts[index],
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    titles[index],
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCashierList(List<Cashier> cashiers) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: cashiers.length,
    itemBuilder: (context, index) {
      var cashier = cashiers[index];
      var roleNames =
          cashier.roles?.map((role) => role.name).join(', ') ?? "No roles";
      return Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          title: Text(
            cashier.name ?? "Unknown",
            style: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            roleNames,
            style: GoogleFonts.kantumruyPro(fontSize: 11, color: Colors.grey),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              cashier.avatar ?? 'https://example.com/default-avatar.png',
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cashier.totalAmount!.toKhmerCurrency(),
                style: GoogleFonts.kantumruyPro(fontSize: 14),
              ),
             Text(
  "(${cashier.percentageChange!.toDouble()})%",  // Handle null case and format
  style: GoogleFonts.kantumruyPro(
    color: Colors.green,
  ),
),

            ],
          ),
        ),
      );
    },
  );
}


  Widget buildProductTypeStats() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'ស្ថិតិប្រភេទផលិតផល',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Donut(),
        ],
      ),
    );
  }

  Widget buildSalesStats() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'ស្ថិតិការលក់',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const ChartApp(),
        ],
      ),
    );
  }
}

class SalesCardWidget extends StatefulWidget {
  @override
  _SalesCardWidgetState createState() => _SalesCardWidgetState();
}

class _SalesCardWidgetState extends State<SalesCardWidget> {
  int? selectedIndex; // Move selectedIndex to the widget's state

  Widget buildSalesCard() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ការលក់', // Sales Title
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text("ថ្ងៃនេះ", style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              showCustomBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: calendar.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Image(
                                          height: 22,
                                          image: AssetImage(calendar[index]),
                                        ),
                                        title: Text(
                                          title[index],
                                          style: GoogleFonts.kantumruyPro(),
                                        ),
                                        trailing: selectedIndex == index
                                            ? const Icon(Icons.check,
                                                color: Colors
                                                    .green) // Show check icon if selected
                                            : null,
                                        onTap: () {
                                          setState(() {
                                            selectedIndex =
                                                index; // Update selected index
                                          });

                                          Navigator.pop(
                                              context); // Close the bottom sheet

                                          if (index == 5) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DateChooser(),
                                              ),
                                            );
                                          } else {
                                            print(
                                                'No page available for this index');
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sales Amount
                Text(
                  '60,998,900 ៛', // Total Sales
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                // Percentage Growth
                Row(
                  children: [
                    Text(
                      'កើនឡើង', // Increase Percentage
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' +15% (6,099,900)', // Increase Percentage
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ' ធៀបនឹងម្សិលមិញ', // Compared to yesterday
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSalesCard();
  }
}

class ChartApp extends StatefulWidget {
  const ChartApp({super.key});

  @override
  ChartAppState createState() => ChartAppState();
}

class ChartAppState extends State<ChartApp> {
  late var data = <ChartData>[]; // Initialize data with an empty list
  late ServiceController service; // Instance of your service class

  @override
  void initState() {
    super.initState();
    // _tooltip = TooltipBehavior(enable: true);
    service = ServiceController(); // Ensure this is correctly initialized
    fetchData();
  }

  void fetchData() async {
    try {
      StatisticSales stats = await service.fetchSaleStatistics();
      setState(() {
        data = List.generate(
          stats.labels!.length,
          (index) =>
              ChartData(stats.labels![index], stats.data![index].toDouble()),
        );
      });
    } catch (e) {
      print('Failed to fetch sales statistics: $e');
      // Consider adding user feedback here, e.g., using a Snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatisticChat(data: data);
  }
}

class CashierSection extends StatefulWidget {
  @override
  _CashierSectionState createState() => _CashierSectionState();
}

class _CashierSectionState extends State<CashierSection> {
  int _selectedIndex = 0; // State variable to track the selected icon
  late Future<List<Cashier>> futureCashier;

  final ServiceController service = ServiceController();

  @override
  void initState() {
    super.initState();
    futureCashier = service.fetchCashier(); // Initialize futureCashier
  }

  // Function to set the selected index
  void _onIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to return the corresponding widget based on selected index
  Widget _getContentByIndex(int index) {
    switch (index) {
      case 0:
        // Display Cashier List (as per the original code)
        return FutureBuilder<List<Cashier>>(
          future: futureCashier,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                log("Error: ${snapshot.error}"); // Corrected error logging
                return UI.spinKit();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return UI.spinKit();
              }
              return buildCashierList(snapshot.data!);
            }
            return UI.spinKit();
          },
        );
      case 1:
        // Display content for Pie Chart
        return DonutPie(
          data: [
            DonutPieData(
              'ជឹង គឹមឡាយ(${NumberFormat.decimalPattern().format(2223000)})',
              2223000,
              HColors.danger,
            ),
            DonutPieData(
              'គង់ ចាន់គីរី(${NumberFormat.decimalPattern().format(2300000)})',
              2300000,
              HColors.success,
            ),
            DonutPieData(
              'រឿន សុផាត់(${NumberFormat.decimalPattern().format(1203000)})',
              1203000,
              HColors.secondaryColor(),
            ),
            DonutPieData(
              'ឃុយ​ បូរិន សត្យា(${NumberFormat.decimalPattern().format(103000)})',
              103000,
              HColors.backgroundColor(),
            ),
          ],
          title: "Cashiers",
        );
      case 2:
        // Display content for Bar Chart
        return StatisticChat(
          data: [
            ChartData(
              'ជឹង គឺមឡាយ',
              2223000,
            ),
            ChartData(
              'គង់ ចាន់គីរី',
              2300000,
            ),
            ChartData(
              'រឿន សុផាត់',
              1203000,
            ),
            ChartData(
              'ឃុយ​ បូរិន សត្យា',
              103000,
            ),
          ],
        );
      default:
        return Container(); // Return empty container if no match
    }
  }

  Widget buildCashierList(List<Cashier> cashiers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cashiers.length,
      itemBuilder: (context, index) {
        var cashier = cashiers[index];
        var roleNames =
            cashier.roles?.map((role) => role.name).join(', ') ?? "No roles";
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(
              cashier.name ?? "Unknown",
              style: GoogleFonts.kantumruyPro(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              roleNames,
              style: GoogleFonts.kantumruyPro(fontSize: 11,),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                cashier.avatar ?? 'https://example.com/default-avatar.png',
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cashier.totalAmount!
                      .toKhmerCurrency(), // Placeholder for currency conversion
                  style: GoogleFonts.kantumruyPro(fontSize: 14),
                ),
                Text(
                  "(${cashier.percentageChange!.toDouble()}%)",
                  style: GoogleFonts.kantumruyPro(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'អ្នកគិតប្រាក់',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    // List Icon (Index 0)
                    IconButton(
                      icon: Icon(
                        Icons.list,
                        color: _selectedIndex == 0
                            ? HColors.primaryColor()
                            : const Color(0xFF64748B),
                      ),
                      onPressed: () => _onIconTap(0),
                    ),
                    // Pie Chart Icon (Index 1)
                    IconButton(
                      icon: Icon(
                        Icons.pie_chart,
                        color: _selectedIndex == 1
                            ? HColors.primaryColor()
                            : const Color(0xFF64748B),
                      ),
                      onPressed: () => _onIconTap(1),
                    ),
                    // Bar Chart Icon (Index 2)
                    IconButton(
                      icon: Icon(
                        Icons.bar_chart,
                        color: _selectedIndex == 2
                            ? HColors.primaryColor()
                            : const Color(0xFF64748B),
                      ),
                      onPressed: () => _onIconTap(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Display content based on selected icon
          _getContentByIndex(_selectedIndex),
        ],
      ),
    );
  }
}

class Donut extends StatefulWidget {
  const Donut({super.key});

  @override
  DonutState createState() => DonutState();
}

class DonutState extends State<Donut> {
  late ServiceController statisticService;
  List<DonutPieData> data = [];

  @override
  void initState() {
    super.initState();
    statisticService = ServiceController();
    fetchData();
  }

  void fetchData() async {
    try {
      StatisticProductType stats =
          await statisticService.fetchProductTypeStatistics();
      setState(() {
        data = List.generate(
          stats.labels!.length,
          (index) => DonutPieData(
            stats.labels![index],
            stats.data![index],
            _getColor(index), // Assign colors dynamically
          ),
        );
      });
    } catch (e) {
      print('Failed to fetch statistics: $e');
    }
  }

  Color _getColor(int index) {
    final double hue = (index * 137.5) % 360;
    return HSLColor.fromAHSL(1.0, hue, 0.6, 0.6).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return DonutPie(
      data: data,
      title: 'Product Types', // Customize title if needed
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 12.0 : 8.0,
      height: isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? HColors.primaryColor() : Colors.black,
      ),
    );
  }
}

class DateChooser extends StatelessWidget {
  const DateChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
