part of '_sidebar.dart';

class SidebarItemModel {
  final String name;
  final String iconPath;
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.iconPath,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
          sidebarItemType != SidebarItemType.submenu ||
              (submenus != null && submenus.isNotEmpty),
          'Sub menus cannot be null or empty if the item type is submenu',
        );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
  });
}

class GroupedMenuModel {
  final String name;
  final List<SidebarItemModel> menus;

  GroupedMenuModel({
    required this.name,
    required this.menus,
  });
}

enum SidebarItemType { tile, submenu }

List<GroupedMenuModel> get _groupedMenus {
  return <GroupedMenuModel>[
    // Application Group
    GroupedMenuModel(
      //name: 'Application',
      name: l.S.current.application,
      menus: [
        SidebarItemModel(
          // name: 'Dashboard',
          name: l.S.current.dashboard,
          iconPath: 'assets/images/sidebar_icons/home-dash-star.svg',
          navigationPath: '/dashboard',
        ),
        if (SharedPreferencesProvider.instance.profile!.isAdminUser)
          SidebarItemModel(
            //name: 'Widgets',
            name: 'Business',
            iconPath: 'assets/images/sidebar_icons/kanban.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/admin',
            submenus: [
              SidebarSubmenuModel(
                // name: 'General',
                name: 'Settings',
                navigationPath: 'business_setting',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: 'Locations',
                navigationPath: 'business_location',
              ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isAdminUser)
          SidebarItemModel(
            //name: 'Widgets',
            name: 'Master',
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/master',
            submenus: [
              SidebarSubmenuModel(
                // name: 'General',
                name: 'Products',
                navigationPath: 'product',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: 'Timezones',
                navigationPath: '',
              ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isFactoryAdminUser)
          SidebarItemModel(
            //name: 'Widgets',
            name: l.S.current.factory_factory_admin,
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/factory-admin',
            submenus: [
              SidebarSubmenuModel(
                // name: 'General',
                name: l.S.current.factory_raw_material,
                navigationPath: 'ingredient',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.factory_formula,
                navigationPath: 'formula',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.factory_planning,
                navigationPath: 'production-batch',
              ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isFactorySupervisorUser)
          SidebarItemModel(
            //name: 'Widgets',
            name: l.S.current.factory_stage,
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/stage',
            submenus: [
              SidebarSubmenuModel(
                // name: 'General',
                name: l.S.current.stage_mixing,
                navigationPath: 'mixing',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_incubation,
                navigationPath: 'incubation',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_screening,
                navigationPath: 'screening',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_final_processing,
                navigationPath: 'final-processing',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_quality_contol_check,
                navigationPath: 'qc-check',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_packaging,
                navigationPath: 'packaging',
              ),
              SidebarSubmenuModel(
                // name: 'Chart',
                name: l.S.current.stage_inventory_for_finished_products,
                navigationPath: 'inventory',
              ),
            ],
          ),
        SidebarItemModel(
          // name: 'Calendar ',
          name: l.S.current.Logout,
          iconPath: 'assets/images/sidebar_icons/note-list.svg',
          navigationPath: '/authentication/signin',
        ),
      ],
    ),
  ];
}
