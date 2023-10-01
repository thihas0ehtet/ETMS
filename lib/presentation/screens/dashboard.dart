import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:get/get.dart';
import '../../app/config/config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int visit = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Expanded(child: Get.arguments),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomBarInspiredOutside(
                  items: items,
                  backgroundColor: Colors.white,
                  color: ColorResources.primary700,
                  colorSelected: ColorResources.primary700,
                  indexSelected: visit,
                  onTap: (int index) => setState(() {
                    visit = index;
                    // switch (index){
                    //   case 1:  ref.read(tabIndex.notifier).state = 1;
                    //   context.goNamed(RouteNames.addBlog); break;
                    //   case 2: ref.read(tabIndex.notifier).state = 2;
                    //   context.goNamed(RouteNames.account);break;
                    //   default: ref.read(tabIndex.notifier).state = 0;
                    //   context.goNamed(RouteNames.viewBlog); break;
                    // }
                  }),
                  chipStyle: ChipStyle(convexBridge: false,
                      background:ColorResources.background,notchSmoothness: NotchSmoothness.sharpEdge),
                  itemStyle: ItemStyle.circle,
                  animated: true,
                ),
              ),
            ],
          ),
        ));
  }
}

const List<TabItem> items = [
  TabItem(
    icon: Icons.home,
    title: 'Home'
  ),
  TabItem(
    icon: Icons.add,
    title: 'All'
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile'
  ),
];
