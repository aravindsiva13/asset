import 'package:asset_management_local/main_pages/login_screen/login_screen.dart';
import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),
          ChangeNotifierProvider<BoolProvider>(create: (_) => BoolProvider()),
          ChangeNotifierProvider<AssetProvider>(create: (_) => AssetProvider()),
        ],
        child: Consumer<AppTheme>(builder: (context, theme, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
              home: const LoginInScreen());
        }));
  }
}
