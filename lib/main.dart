import 'package:budsy/app/router.dart';
import 'package:budsy/auth/bloc/auth_bloc.dart';
import 'package:budsy/auth/repository/auth_repository.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/journal/bloc/journal_bloc.dart';
import 'package:budsy/journal/cubit/feelings_cubit.dart';
import 'package:budsy/journal/repository/feelings_repository.dart';
import 'package:budsy/journal/repository/journal_repository.dart';
import 'package:budsy/login/cubit/login_cubit.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/bloc/stash_bloc.dart';
import 'package:budsy/stash/repository/product_repository.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/servicecontrol/v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_PUBLIC_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider(
          create: (context) => JournalRepository(),
        ),
        RepositoryProvider(
          create: (context) => FeelingsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                LoginCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => StashBloc(
              productRepository: context.read<ProductRepository>(),
              authBloc: context.read<AuthBloc>(),
            )..add(FetchStash(context.read<AuthBloc>().state.user!.id)),
          ),
          BlocProvider(
            create: (context) => ProductDetailsBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => JournalBloc(
              journalRepository: context.read<JournalRepository>(),
            )..add(LoadJournal()),
          ),
          BlocProvider(
            create: (context) => FeelingsCubit(
              feelingsRepository: context.read<FeelingsRepository>(),
            )..getFeelings(),
          )
        ],
        child: MaterialApp.router(
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          routeInformationProvider: goRouter.routeInformationProvider,
          title: 'Flutter Demo',
          key: scaffoldKey,
          theme: FlexThemeData.light(
            scheme: FlexScheme.amber,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 22,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 1.0,
            lightIsWhite: true,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              splashType: FlexSplashType.inkRipple,
              defaultRadius: 16.0,
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              segmentedButtonSchemeColor: SchemeColor.primary,
              inputDecoratorUnfocusedHasBorder: false,
              fabSchemeColor: SchemeColor.tertiary,
              popupMenuRadius: 6.0,
              popupMenuElevation: 4.0,
              alignedDropdown: true,
              dialogElevation: 3.0,
              dialogRadius: 20.0,
              useInputDecoratorThemeInDialogs: true,
              snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
              drawerIndicatorSchemeColor: SchemeColor.primary,
              bottomSheetRadius: 20.0,
              bottomSheetElevation: 2.0,
              bottomSheetModalElevation: 3.0,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarMutedUnselectedIcon: false,
              bottomNavigationBarBackgroundSchemeColor:
                  SchemeColor.surfaceVariant,
              menuRadius: 6.0,
              menuElevation: 4.0,
              menuBarRadius: 0.0,
              menuBarElevation: 1.0,
              navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              navigationBarMutedUnselectedLabel: false,
              navigationBarSelectedIconSchemeColor: SchemeColor.background,
              navigationBarMutedUnselectedIcon: false,
              navigationBarIndicatorSchemeColor: SchemeColor.primary,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarBackgroundSchemeColor: SchemeColor.background,
              navigationBarElevation: 1.0,
              navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
              navigationRailMutedUnselectedLabel: false,
              navigationRailSelectedIconSchemeColor: SchemeColor.background,
              navigationRailMutedUnselectedIcon: false,
              navigationRailIndicatorSchemeColor: SchemeColor.primary,
              navigationRailIndicatorOpacity: 1.00,
            ),
            keyColors: const FlexKeyColors(
              useTertiary: true,
              keepPrimary: true,
              keepSecondary: true,
              keepTertiary: true,
            ),
            tones: FlexTones.highContrast(Brightness.light)
                .onMainsUseBW()
                .onSurfacesUseBW()
                .surfacesUseBW(),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.amber,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 18,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 2.0,
            darkIsTrueBlack: true,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              splashType: FlexSplashType.inkRipple,
              defaultRadius: 16.0,
              elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
              elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
              segmentedButtonSchemeColor: SchemeColor.primary,
              inputDecoratorSchemeColor: SchemeColor.primary,
              inputDecoratorBackgroundAlpha: 28,
              inputDecoratorUnfocusedHasBorder: false,
              fabSchemeColor: SchemeColor.tertiary,
              popupMenuRadius: 6.0,
              popupMenuElevation: 4.0,
              alignedDropdown: true,
              dialogElevation: 3.0,
              dialogRadius: 20.0,
              useInputDecoratorThemeInDialogs: true,
              snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
              drawerIndicatorSchemeColor: SchemeColor.primary,
              bottomSheetRadius: 20.0,
              bottomSheetElevation: 2.0,
              bottomSheetModalElevation: 3.0,
              bottomNavigationBarMutedUnselectedLabel: false,
              bottomNavigationBarMutedUnselectedIcon: false,
              bottomNavigationBarBackgroundSchemeColor:
                  SchemeColor.surfaceVariant,
              menuRadius: 6.0,
              menuElevation: 4.0,
              menuBarRadius: 0.0,
              menuBarElevation: 1.0,
              navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              navigationBarMutedUnselectedLabel: false,
              navigationBarSelectedIconSchemeColor: SchemeColor.background,
              navigationBarMutedUnselectedIcon: false,
              navigationBarIndicatorSchemeColor: SchemeColor.primary,
              navigationBarIndicatorOpacity: 1.00,
              navigationBarBackgroundSchemeColor: SchemeColor.background,
              navigationBarElevation: 1.0,
              navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
              navigationRailMutedUnselectedLabel: false,
              navigationRailSelectedIconSchemeColor: SchemeColor.background,
              navigationRailMutedUnselectedIcon: false,
              navigationRailIndicatorSchemeColor: SchemeColor.primary,
              navigationRailIndicatorOpacity: 1.00,
            ),
            keyColors: const FlexKeyColors(
              useTertiary: true,
              keepPrimary: true,
              keepTertiary: true,
              keepPrimaryContainer: true,
              keepSecondaryContainer: true,
            ),
            tones: FlexTones.highContrast(Brightness.dark)
                .onMainsUseBW()
                .onSurfacesUseBW(),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
