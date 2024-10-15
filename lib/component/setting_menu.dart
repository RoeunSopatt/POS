import 'package:flutter/material.dart'; 

class DrawerMenu extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String label;
  final IconData icon;
  const DrawerMenu({
    required this.onTap,
    required this.iconPath,
    required this.label,
    required this.icon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(bottom: 15),
        child: Row( 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            Icon(
              icon
            ),
            const SizedBox(
              width: 10,
            ), 
            Text(
              label, 
            ),
          ],
        ),
      ),
    );
  }
}