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
    GroupedMenuModel(
      name: l.S.current.application,
      menus: [
        SidebarItemModel(
          name: l.S.current.dashboard,
          iconPath: 'assets/images/sidebar_icons/home-dash-star.svg',
          navigationPath: '/dashboard',
        ),
        if (SharedPreferencesProvider.instance.profile!.isAdminUser)
          SidebarItemModel(
            name: 'Business',
            iconPath: 'assets/images/sidebar_icons/kanban.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/admin',
            submenus: [
              SidebarSubmenuModel(
                name: 'Settings',
                navigationPath: 'business_setting',
              ),
              SidebarSubmenuModel(
                name: 'Locations',
                navigationPath: 'business_location',
              ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isAdminUser)
          SidebarItemModel(
            name: 'Master',
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/master',
            submenus: [
              SidebarSubmenuModel(
                name: 'Products',
                navigationPath: 'product',
              ),
              SidebarSubmenuModel(
                name: 'Timezones',
                navigationPath: '',
              ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isFactoryAdminUser)
          SidebarItemModel(
            name: l.S.current.factory_factory_admin,
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/factory-admin',
            submenus: [
              SidebarSubmenuModel(
                name: l.S.current.factory_raw_material,
                navigationPath: 'sourcing-material',
              ),
              // SidebarSubmenuModel(
              //   name: l.S.current.factory_formula,
              //   navigationPath: 'formula',
              // ),
              // SidebarSubmenuModel(
              //   name: l.S.current.factory_planning,
              //   navigationPath: 'production-batch',
              // ),
            ],
          ),
        if (SharedPreferencesProvider.instance.profile!.isFactorySupervisorUser)
          SidebarItemModel(
            name: l.S.current.factory_stage,
            iconPath: 'assets/images/sidebar_icons/note-list.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/stage',
            submenus: [
              SidebarSubmenuModel(
                name: 'Pre-processing QC',
                navigationPath: 'pre-processing-qc',
              ),
              SidebarSubmenuModel(
                name: 'Pre-cleaning',
                navigationPath: 'pre-cleaning',
              ),
              SidebarSubmenuModel(
                name: 'Drying',
                navigationPath: 'drying',
              ),
              SidebarSubmenuModel(
                name: 'Storage',
                navigationPath: 'storage',
              ),
              SidebarSubmenuModel(
                name: 'Husking',
                navigationPath: 'husking',
              ),
              SidebarSubmenuModel(
                name: 'Brown Rice Milling',
                navigationPath: 'brown-rice-milling',
              ),
              SidebarSubmenuModel(
                name: 'De-stoning',
                navigationPath: 'de-stoning',
              ),
              SidebarSubmenuModel(
                name: 'Whitening & Semi Polishing',
                navigationPath: 'whitening-semi-polishing',
              ),
              SidebarSubmenuModel(
                name: 'Sortex',
                navigationPath: 'sortex',
              ),
              SidebarSubmenuModel(
                name: 'Final QC',
                navigationPath: 'final-qc',
              ),
              SidebarSubmenuModel(
                name: 'Packaging',
                navigationPath: 'packaging',
              ),
              SidebarSubmenuModel(
                name: 'Final Inventory',
                navigationPath: 'final-inventory',
              ),
            ],
          ),
        SidebarItemModel(
          name: l.S.current.Logout,
          iconPath: 'assets/images/sidebar_icons/note-list.svg',
          navigationPath: '/authentication/signin',
        ),
      ],
    ),
  ];
}
