part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;

  final FirebaseService _auth = FirebaseService();

  // Future<Map<String, dynamic>>;

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(
      context,
      '/sign-in',
    );
  }

  @override
  void initState() {
    User? user = _auth.currentUser;
    userId = user!.uid;
    userData = _auth.getUserData(userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("User data not found."),
            );
          }
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  welcomeText,
                  style: welcomeTextStyle,
                ),
                Text(
                  "Email saya: ${_auth.currentUser.email}",
                  style: subWelcomeTextStyle.copyWith(fontSize: 16),
                ),
                Text(
                  'UID: ${_auth.currentUser.uid}',
                  style: subWelcomeTextStyle,
                ),
                Text(
                  'Nama: ${snapshot.data!['first_name']} ${snapshot.data!['last_name']}',
                  style: subWelcomeTextStyle,
                ),
                Text(
                  "Role: ${snapshot.data!['role']}",
                  style: subWelcomeTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "Attendace",
                        style: TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/note');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      child: Text(
                        "Notes",
                        style: TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: colorWhite,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
