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
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/sign-in',
      );
    }
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
          var userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  homeProfile(
                    firstName: userData['first_name'],
                    lastName: userData['last_name'],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  homeButton(widget: [
                    homeCard(
                      color: Colors.blue,
                      iconData: Icons.person,
                      text: "Profile",
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    homeCard(
                      color: Colors.green,
                      iconData: Icons.timelapse,
                      text: "Attendance",
                      onPressed: () {
                        Navigator.pushNamed(context, '/home-attendace');
                      },
                    ),
                  ]),
                  homeButton(widget: [
                    homeCard(
                      color: Colors.amber,
                      iconData: Icons.note_alt,
                      text: "Note",
                      onPressed: () {
                        Navigator.pushNamed(context, '/note');
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    homeCard(
                      color: Colors.red,
                      iconData: Icons.logout_rounded,
                      text: "Sign Out",
                      onPressed: () {
                        _signOut();
                      },
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget homeCard(
    {required IconData iconData,
    required String text,
    required Color color,
    required VoidCallback onPressed}) {
  return Expanded(
    child: ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: color,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget homeButton({required List<Widget> widget}) {
  return Row(
    children: widget,
  );
}

Widget clockAndNotes() {
  return Row();
}

Widget homeProfile({
  required String firstName,
  required String lastName,
}) {
  return Column(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage("assets/images/dummy_picture.webp"),
        minRadius: 100,
        maxRadius: 150,
      ),
      const SizedBox(
        height: 12,
      ),
      Text(
        "👋 Hello, $firstName $lastName",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
