import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';
import 'views/home_feed_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()..fetchInitialPosts()),
      ],
      child: const InstagramApp(),
    ),
  );
}

class InstagramApp extends StatelessWidget {
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF262626),
          primary: const Color(0xFF262626),
          secondary: const Color(0xFF0095F6), // Official IG Blue
          surface: Colors.white,
        ),
        fontFamily: 'system-ui', 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF262626),
          centerTitle: false,
        ),
        dividerTheme: const DividerThemeData(
          thickness: 0.5,
          color: Color(0xFFDBDBDB),
          space: 0.5,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF262626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      home: const HomeFeedView(),
    );
  }
}