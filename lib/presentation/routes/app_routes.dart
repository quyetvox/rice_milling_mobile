// 📦 Package imports:
import 'package:rice_milling_mobile/infrastructure/locals/shared_manager.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_location/index.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_setting/index.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/master_product/index.dart';
import 'package:rice_milling_mobile/presentation/pages/dashboard/pages/base.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/sourcing_material/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/brown_rice_milling/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/de_stoning/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/drying/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/husking/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_cleaning/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_processing_qc/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_inventory/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_qc/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/sortex/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/storage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/whitening_semi_polishing/index.dart';

// 🌎 Project imports:
import '../pages/pages.dart';
import '../../application/providers/providers.dart';

abstract class AcnooAppRoutes {
  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _emailShellNavigatorKey = GlobalKey<NavigatorState>();

  //--------------Navigator Keys--------------//

  static const _initialPath = '/';
  static final routerConfig = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: _initialPath,
    routes: [
      // Landing Route Handler
      GoRoute(
        path: _initialPath,
        redirect: (context, state) {
          final _appLangProvider = Provider.of<AppLanguageProvider>(context);

          if (state.uri.queryParameters['rtl'] == 'true') {
            _appLangProvider.isRTL = true;
          }
          if (SharedPreferencesProvider.instance.accessToken.isEmpty) {
            return '/authentication/signin';
          }
          return '/dashboard';
        },
      ),

      // Global Shell Route
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: ShellRouteWrapper(child: child),
          );
        },
        routes: [
          // Dashboard Routes
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard') {
                return '/dashboard/base';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'base',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardBaseView(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: '/admin/business_setting',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BussinessSettingView(),
            ),
          ),

          GoRoute(
            path: '/admin/business_location',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BussinessLocationView(),
            ),
          ),

          GoRoute(
            path: '/master/product',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MasterProductView(),
            ),
          ),

          GoRoute(
            path: '/factory-admin/sourcing-material',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SourcingMaterialView(),
            ),
          ),

          GoRoute(
            path: '/stage/pre-processing-qc',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PreProcessingQCView(),
            ),
          ),
          GoRoute(
            path: '/stage/pre-cleaning',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PreCleaningView(),
            ),
          ),
          GoRoute(
            path: '/stage/drying',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DryingView(),
            ),
          ),
          GoRoute(
            path: '/stage/storage',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StorageView(),
            ),
          ),
          GoRoute(
            path: '/stage/husking',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HuskingView(),
            ),
          ),
          GoRoute(
            path: '/stage/brown-rice-milling',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BrownRiceMillingView(),
            ),
          ),
          GoRoute(
            path: '/stage/de-stoning',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DeStoningView(),
            ),
          ),
          GoRoute(
            path: '/stage/whitening-semi-polishing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WhiteningAndSemiPolishingView(),
            ),
          ),
          GoRoute(
            path: '/stage/sortex',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SortexView(),
            ),
          ),
          GoRoute(
            path: '/stage/final-qc',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FinalQCView(),
            ),
          ),
          GoRoute(
            path: '/stage/packaging',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PackagingView(),
            ),
          ),
          GoRoute(
            path: '/stage/final-inventory',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FinalInventoryView(),
            ),
          ),

          //--------------Application Section--------------//
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: CalendarView(),
            ),
          ),
        ],
      ),

      // Full Screen Pages
      GoRoute(
        path: '/authentication/signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupView(),
        ),
      ),
      GoRoute(
        path: '/authentication/signin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninView(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}
