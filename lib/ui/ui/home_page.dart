part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String emailSaya = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              welcomeText,
              style: welcomeTextStyle,
            ),
            Text(
              "Email saya: $emailSaya",
              style: welcomeTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
