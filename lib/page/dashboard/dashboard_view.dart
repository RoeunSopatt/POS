import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/helper/colors.dart';
import 'package:mobile/entity/model/user.dart';
import 'package:mobile/page/home/home_view.dart';
import 'package:mobile/page/listtransaction/cashier/cashiersale.dart';
import 'package:mobile/page/listtransaction/transactions.dart';
import 'package:mobile/page/notification/notification.dart';
import 'package:mobile/page/pos/pos.dart';
import 'package:mobile/page/product/product.dart';
import 'package:mobile/page/setting/profile.dart';
import 'package:mobile/page/user/user.dart';
import 'package:mobile/services/service_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;
  bool _hasUnreadNotifications = false;
  Timer? _notificationTimer;
  final ServiceController userController = Get.find<ServiceController>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    // Load user profile from storage and then set the current role
    userController.load_user_profile_from_storage().then((_) {
      // After user profile is loaded, find the default role
      if (userController.userprofile.value != null &&
          userController.userprofile.value!.roles!.isNotEmpty) {
        // Set the first default role found or the first role as current
        var defaultRole = userController.userprofile.value!.roles!.firstWhere(
            (role) => role.isDefault!,
            orElse: () => userController.userprofile.value!.roles!.first);
        userController.setCurrentRole(defaultRole);
      }
    });

    ever(userController.userprofile, (_) {
      if (mounted) {
        setState(() {});
      }
    });

    _startNotificationCheck();
  }

  void _startNotificationCheck() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 5),
        (Timer t) => _checkForUnreadNotifications());
  }

  void _checkForUnreadNotifications() async {
    try {
      final notificationResponse = await userController.getNotification();
      final bool hasUnread =
          notificationResponse.data!.any((notification) => !notification.read!);
      if (mounted) {
        setState(() {
          _hasUnreadNotifications = hasUnread;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void markNotificationsAsRead() {
    if (mounted) {
      setState(() {
        _hasUnreadNotifications = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

  void changeDefaultRole(RoleUser selectedRole) async {
    final userProfile = userController.userprofile.value;
    if (userProfile == null) {
      Get.snackbar("Error", "User profile not loaded.");
      return;
    }

    if (!userProfile.roles!.any((role) => role.id == selectedRole.id)) {
      Get.snackbar("Error", "User does not have the selected role.");
      return;
    }

    userProfile.roles!
        .forEach((role) => role.isDefault = role.id == selectedRole.id);
    userController.saveUserProfileToStorage(userProfile);
    userController.setCurrentRole(selectedRole);

    Get.snackbar("Success", "Default role switched to ${selectedRole.name}");

    if (mounted) {
      setState(() {
        _pageController.jumpToPage(0);
        _selectedIndex = 0;
      });
    }
  }

  String getImageForRole(RoleUser role) {
    // Example mapping based on role name or ID
    var roleImages = {
      1: 'account-star.png', // Assuming '1' is the ID for Admin
      2: 'account-cash.png', // Assuming '2' is the ID for Cashier
    };

    // Default image if no specific one is found for the role
    return 'assets/images/${roleImages[role.id] ?? 'default.png'}';
  }

  void _showRoleSelectionBottomSheet(List<RoleUser> roles) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130),
                child: Container(
                  width: 120,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                    itemCount: roles.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      return ListTile(
                        onTap: () {
                          changeDefaultRole(role);
                          Navigator.of(context).pop();
                        },
                        leading: Image(
                          height: 22,
                          image: AssetImage(getImageForRole(role)),
                        ),
                        title: Text(
                          role.name ?? '',
                          style: GoogleFonts.kantumruyPro(),
                        ),
                        trailing: role.isDefault!
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isDrawerOpen) toggleDrawer();
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        var userProfile = userController.userprofile.value;
        if (userProfile == null || userProfile.roles == null) {
          return UI.spinKit();
        }

        bool isAdmin =
            userProfile.roles!.any((role) => role.id == 1 && role.isDefault!);
        List<Widget> pages = isAdmin ? _defaultPages() : _restrictedPages();
        List<BottomNavigationBarItem> items =
            isAdmin ? _defaultNavItems() : _restrictedNavItems();

        // Ensure _selectedIndex is within the bounds of the items.
        if (_selectedIndex >= items.length) {
          _selectedIndex = items.length - 1;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo/posmobile1.png'),
                    ),
                  ),
                ),
                // const SizedBox(width: 45),
                Obx(() => Text(
                      "${userController.currentRole.value.name}",
                      style: GoogleFonts.kantumruyPro(fontSize: 18),
                    )),
                    Row(
                      children: [
                        Stack(
                                          children: [
                                            Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications, size: 26),
                          onPressed: () {
                            Get.to(() => const Notifications(),
                                    transition: Transition.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 350))
                                ?.then((_) => markNotificationsAsRead());
                          },
                        ),
                                            ),
                                            if (_hasUnreadNotifications)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        )
                                          ],
                                        ),
                                        Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onPressed: () =>
                        _showRoleSelectionBottomSheet(userProfile.roles!),
                  ),
                ),
              ),
                      ],
                    ),
              
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: Colors.grey, height: 1.0),
            ),
            
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onNavItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: HColors.primaryColor(),
            items: items,
            selectedLabelStyle: GoogleFonts.kantumruyPro(
              fontSize: 11.0,
              color: HColors.primaryColor(),
            ),
            unselectedLabelStyle: GoogleFonts.kantumruyPro(
              fontSize: 11.0,
              color: Colors.grey,
            ),
          ),
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              children: pages,
              onPageChanged: (index) => setState(() {
                _selectedIndex = index;
              }),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _defaultPages() => [
        const Home(),
        const ListingTransaction(),
        const ProductPage(),
        UserList(),
        ProfileView(),
      ];

  List<Widget> _restrictedPages() => [
        const POS(),
        const CashierListTransaction(),
        ProfileView(),
      ];

  List<BottomNavigationBarItem> _defaultNavItems() => [
        BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
            label: "ទំព័រដើម"),
        BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset('assets/images/cart2.png', height: 22)
                : const Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                  ),
            label: "ការលក់"),
        BottomNavigationBarItem(
          icon: _selectedIndex == 2
              ? Image.asset('assets/images/pack.png', height: 22)
              : Image.asset('assets/images/package2.png', height: 22),
          label: "ផលិតផល",
        ),
        BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(Icons.groups_2)
                : const Icon(Icons.groups_2_outlined),
            label: "អ្នកប្រើប្រាស់"),
        BottomNavigationBarItem(
          icon: _selectedIndex == 4
              ? Image.asset('assets/images/acc.png', height: 22)
              : Image.asset('assets/images/account.png', height: 22),
          label: "គណនី",
        ),
      ];

  List<BottomNavigationBarItem> _restrictedNavItems() => [
        const BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_rounded), label: "ការបញ្ជាទិញ"),
        BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset('assets/images/cart2.png', height: 22)
                : const Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                  ),
            label: "ការលក់"),
        BottomNavigationBarItem(
          icon: _selectedIndex == 2
              ? Image.asset('assets/images/acc.png', height: 22)
              : Image.asset('assets/images/account.png', height: 22),
          label: "គណនី",
        ),
      ];

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleDrawer() {
    if (!_animationController.isAnimating) {
      setState(() {
        _isDrawerOpen = !_isDrawerOpen;
      });
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
}
