part of '../../pages.dart';

class HomeAttendancePage extends StatefulWidget {
  const HomeAttendancePage({super.key});

  @override
  State<HomeAttendancePage> createState() => _HomeAttendancePageState();
}

class _HomeAttendancePageState extends State<HomeAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Attendance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              attendanceTitle("Feature"),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        featureCard(Icons.timer, "Check In", Colors.blue, () {
                      Navigator.pushNamed(context, '/attendance');
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: featureCard(
                        Icons.logout_outlined, "Check Out", Colors.red, () {
                      Navigator.pushNamed(context, '/leave');
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                        featureCard(Icons.history, "History", Colors.amber, () {
                      Navigator.pushNamed(context, '/history');
                    }),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              attendanceTitle("Check In"),
              FutureBuilder(
                  future: AttendanceServie().checkInCount(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    Map<String, int> count = snapshot.data!;
                    return Column(
                      children: [
                        descAttendanceTitle(
                            "You've have check in about ${count['checkIn']} times"),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            checkCard(Icons.timer, "Check In", Colors.blue,
                                count['Attendance'], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            checkCard(Icons.run_circle_outlined, "Late",
                                Colors.amber, count['Late'], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            checkCard(Icons.person_off_outlined, "Absent",
                                Colors.red, count['Absent'], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                          ],
                        ),
                      ],
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              attendanceTitle("Check Out"),
              FutureBuilder(
                  future: AttendanceServie().checkOutCount(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }

                    Map<String, int> count = snapshot.data!;

                    return Column(
                      children: [
                        descAttendanceTitle(
                            "You've have check out about ${count['checkOut']} times"),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            checkCard(Icons.sick_rounded, "Sick", Colors.red,
                                count["Sick"], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            checkCard(Icons.info_outline, "Permission",
                                Colors.amber, count['Permission'], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            checkCard(Icons.other_houses_outlined, "Other",
                                Colors.blueGrey, count["Other"], () {
                              Navigator.pushNamed(context, '/history');
                            }),
                          ],
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget checkCard(
    IconData icon, String title, Color color, int? count, VoidCallback onTap) {
  return Container(
    padding: const EdgeInsets.all(10),
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$count times $title",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(
          icon,
          size: 50,
          color: Colors.white,
        ),
      ],
    ),
  );
}

Widget featureCard(
    IconData icon, String title, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget descAttendanceTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget attendanceTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
