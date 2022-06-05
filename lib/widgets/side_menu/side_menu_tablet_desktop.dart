import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/provider/app_provider.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/widgets/navbar/navbar_logo.dart';
import 'package:admin_dashboard/widgets/side_menu/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuTabletDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.deepOrange,
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.deepOrange.shade600],
          ),
          boxShadow: [
            BoxShadow(
                color: (Colors.grey[200])!,
                offset: Offset(3, 5),
                blurRadius: 17)
          ]),
      width: 250,
      child: Container(
        child: Column(
          children: [
            NavBarLogo(),
            SideMenuItemDesktop(
              icon: Icons.dashboard,
              text: 'Dashboard',
              active: appProvider.currentPage == DisplayedPage.HOME,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.HOME);
                locator<NavigationService>().navigateTo(HomeRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.people,
              text: 'Users',
              active: appProvider.currentPage == DisplayedPage.USERS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.USERS);

                locator<NavigationService>().navigateTo(UsersRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.manage_accounts,
              text: 'Users Roles',
              active: appProvider.currentPage == DisplayedPage.USERSROLES,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.USERSROLES);
                locator<NavigationService>().navigateTo(UsersRolesRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.category,
              text: 'Categories',
              active: appProvider.currentPage == DisplayedPage.CATEGORIES,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.CATEGORIES);
                locator<NavigationService>().navigateTo(CategoriesRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.branding_watermark,
              text: 'Brands',
              active: appProvider.currentPage == DisplayedPage.BRANDS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.BRANDS);
                locator<NavigationService>().navigateTo(BrandsRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.list,
              text: 'Products',
              active: appProvider.currentPage == DisplayedPage.PRODUCTS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.PRODUCTS);
                locator<NavigationService>().navigateTo(ProductsRoute);
              },
            ),
            SideMenuItemDesktop(
              icon: Icons.list_alt,
              text: 'Orders',
              active: appProvider.currentPage == DisplayedPage.ORDERS,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.ORDERS);
                locator<NavigationService>().navigateTo(OrdersRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
