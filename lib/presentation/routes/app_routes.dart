// 📦 Package imports:
import 'package:rice_milling_mobile/infrastructure/locals/shared_manager.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_location/index.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_setting/index.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/master_product/index.dart';
import 'package:rice_milling_mobile/presentation/pages/dashboard/pages/base.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_processing_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/incubation_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/mixing_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/screening_stage/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            path: '/factory-admin/ingredient',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: IngredientView(),
            ),
          ),
          GoRoute(
            path: '/factory-admin/formula',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FormulaView(),
            ),
          ),
          GoRoute(
            path: '/factory-admin/production-batch',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProductionPlanningView(),
            ),
          ),

          GoRoute(
            path: '/stage/mixing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MixingStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/incubation',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: IncubationStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/screening',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScreeningStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/final-processing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FinalProcessingStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/qc-check',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QCCheckStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/packaging',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PackagingStageView(),
            ),
          ),
          GoRoute(
            path: '/stage/inventory',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InvetoryStageView(),
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
