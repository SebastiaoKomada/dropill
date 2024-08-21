import 'dart:developer';

import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/widgets/custom_bottom_app_bar.dart';
import 'package:dropill_project/features/config/config_page.dart';
import 'package:dropill_project/features/home/home_page.dart';
import 'package:dropill_project/features/monitoring/monitoring_page.dart'; // Importar a nova página
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      log(_pageController.page.toString());
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          MonitoringPage(),
          ConfigPage(),
        ],
      ),
      floatingActionButton: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: FloatingActionButton(
            backgroundColor: AppColors.standartBlue,
            foregroundColor: AppColors.white,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, NamedRoute.createMedication);
              if (result != null) {
                // Lógica para atualizar dados se necessário
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomAppBar(
        controller: _pageController,
        selectedItemColor: AppColors.standartBlue,
        children: [
          CustomBottomAppBarItem(
            key: const Key('home'),
            label: 'Home',
            primaryIcon: Icons.home,
            secondaryIcon: Icons.home_outlined,
            onPressed: () => _onItemTapped(0),
          ),
          CustomBottomAppBarItem(
            key: const Key('monitoring'),
            label: 'Monitoring',
            primaryIcon: Icons.monitor,
            secondaryIcon: Icons.monitor_outlined,
            onPressed: () => _onItemTapped(1),
          ),
          CustomBottomAppBarItem(
            key: const Key('config'),
            label: 'Config',
            primaryIcon: Icons.settings,
            secondaryIcon: Icons.settings_outlined,
            onPressed: () => _onItemTapped(2),
          ),
        ],
      ),
    );
  }
}
