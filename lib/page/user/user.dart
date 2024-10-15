import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:excellent_loading/excellent_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/entity/enum/e_ui.dart';
import 'package:mobile/entity/model/user.dart';
import 'package:mobile/page/user/crud/create.dart';
import 'package:mobile/page/user/crud/updatepassword.dart';
import 'package:mobile/page/user/crud/view.dart';
import 'package:mobile/services/service_controller.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> with TickerProviderStateMixin {
  List<DataUser> _users = [];
  final Map<int, AnimationController> _controllers = {};
  final Map<int, Animation<Offset>> _animations = {};
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await ServiceController().fetchAllUsers(); // Fetch all users
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        _users = data['users'];
        _isLoading = false; // Mark loading as complete

        // Initialize animation controllers for each user item
        for (var i = 0; i < _users.length; i++) {
          final controller = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          );
          _controllers[i] = controller;
          _animations[i] = Tween<Offset>(
            begin: Offset.zero, // Start at the current position
            end: const Offset(-0.3, 0), // Slide 30% to the left
          ).animate(controller);
        }
      });
    } catch (error) {
      print('Error fetching users: $error');
      if (!mounted)
        return; // Check again before setting state in case of an error
      setState(() {
        _isLoading = false; // Ensure loading stops even on error
      });
    }
  }

  void _toggleAnimation(int index) {
    final controller = _controllers[index];
    if (controller != null) {
      if (controller.isDismissed) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  void _editUser(DataUser user) {
    // Navigate to the update user screen or handle update logic
    print("Editing user: ${user.name}");
  }

  void _deleteUser(DataUser user) async {
    final ServiceController service = ServiceController();

    // Handle user deletion logic
    await AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(
        child: Text(
          'តើអ្នកពិតជាចង់លុបពិតមែនទេ?',
          style: GoogleFonts.kantumruyPro(),
        ),
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        UI.spinKit();
        bool isDeleted = await service.daleteUser(user.id!);
        if (isDeleted) {
          setState(() {
            _users.removeWhere((item) => item.id == user.id);
            UI.toast(text: "លុបអ្នកប្រើប្រាស់បានជោគជ័យ");
            ExcellentLoading.dismiss();
          });
        } else {
          UI.toast(text: "មិនអាចលុបអ្នកប្រើប្រាស់", isSuccess: false);
        }
      },
    ).show();
  }

  @override
  void dispose() {
    // Dispose of all animation controllers to avoid memory leaks
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'អ្នកប្រើប្រាស់',
      //     style: GoogleFonts.kantumruyPro(fontSize: 14),
      //   ),
      // ),
      body: _isLoading
          ? UI.spinKit() // Show loading spinner while fetching users
          : _users.isEmpty
              ? const Center(child: Text("No users found"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          // final userRole = user.role!
                          //     .map((e) =>
                          //         e.role!.name ??
                          //         'No Role') // Directly provide a default value for null names
                          //     .join('/'); // Join names with a comma
                          final userRole =
                              (user.role != null && user.role!.isNotEmpty)
                                  ? user.role!.first.role?.name ?? 'No Role'
                                  : 'No Role';

                          print(
                              userRole); // Outputs: "Role1, Role2" or "No Role" if null

                          return GestureDetector(
    onHorizontalDragUpdate: (details) {
      if (details.primaryDelta! < -5) {
        _toggleAnimation(index); // Swipe left to show actions
      } else if (details.primaryDelta! > 10) {
        _toggleAnimation(index); // Swipe right to hide actions
      }
    },
    child: Stack(
      children: [
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch to match the row
            children: [
              Container(
                
                decoration: const BoxDecoration(
                  color: Color(0xFF0C7EA5),
                ),
                child: IconButton(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  onPressed: () {
                    Get.to(
                      () => UpdatePassword(id: user.id),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 350),
                    );
                  },
                ),
              ),
              Container(
                // Adjust width for buttons
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () {
                    _deleteUser(user); // Trigger delete logic
                    _controllers[user.id!]?.reverse();
                  },
                ),
              ),
            ],
          ),
        ),
        SlideTransition(
          position: _animations[index]!,
          child: InkWell(
            onTap: () {
              Get.to(
                () => ViewUser(
                  date: user.createdAt!,
                  email: user.email!,
                  name: user.name!,
                  phoneNumber: user.phone!,
                  role: userRole,
                  profilePic: user.avatar!,
                  userId: user.id!,
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 400),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: user.avatar != null
                          ? NetworkImage(user.avatar!)
                          : null,
                      child: user.avatar == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name ?? 'Unknown User'),
                        Text(userRole),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.phone ?? 'No Phone'),
                        Text(user.email ?? 'No Email'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0C7EA5),
        onPressed: () {
          Get.to(
            () => const CreateUser(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 350),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
