import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_app/UI/Screens/auth_layout.dart';
import 'package:manga_app/firebase_options.dart';
import 'package:manga_app/provider/theme.dart';
import 'package:provider/provider.dart';
// import 'package:manga_app/UI/Screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    @override
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          backgroundColor: Color(0xFF1E1E1E)
        ).copyWith(
          onSurface: Colors.black,
          surface: Colors.red
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          // ignore: deprecated_member_use
          fillColor: Colors.red.withOpacity(0.2),
          focusColor: Colors.red,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          elevation: 0,
          scrolledUnderElevation: 0,

          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.amber,
            statusBarIconBrightness: Brightness.dark
          ),
        )
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFF393D5E),

        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          backgroundColor: Color(0xFF393D5E)
        ).copyWith(
          onSurface: Colors.white,
          // ignore: deprecated_member_use
          surface: Colors.white.withOpacity(0.2)
        ),

        iconTheme: const IconThemeData(
          color: Colors.black
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF393D5E),
          foregroundColor: Colors.black,  
          iconTheme: IconThemeData(color: Colors.white),
        ),

        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
          textColor: Colors.white
        ),

      ),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: AuthLayout()
    );
  }
}