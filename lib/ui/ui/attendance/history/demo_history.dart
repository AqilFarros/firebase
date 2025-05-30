import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/service/attendance.dart';
import 'package:flutter/material.dart';

class DemoHistory extends StatefulWidget {
  const DemoHistory({super.key});

  @override
  State<DemoHistory> createState() => _DemoHistoryState();
}

class _DemoHistoryState extends State<DemoHistory> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  List<Map<String, dynamic>> statusNavigation = [
    {
      "title": "Attendance",
      "icon": Icons.timer,
    },
    {
      "title": "Late",
      "icon": Icons.run_circle_outlined,
    },
    {
      "title": "Absent",
      "icon": Icons.person_off_outlined,
    },
    {
      "title": "Sick",
      "icon": Icons.sick_rounded,
    },
    {
      "title": "Permission",
      "icon": Icons.info_outline,
    },
    {
      "title": "Other",
      "icon": Icons.other_houses_outlined,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<Map<String, List<DocumentSnapshot>>>(
          stream: AttendanceServie().getGroupAttendanceStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("No attendance data found"));
            }

            Map<String, List<DocumentSnapshot>> streamData = snapshot.data!;

            List<String> status = streamData.keys.toList();

            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "History Attendance",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: status.length,
                    itemBuilder: (context, index) {
                      String category = status[index];
                      List<DocumentSnapshot> records = streamData[category]!;

                      return Column(
                        children: [
                          Text(
                            category,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  border:
                                      TableBorder.all(color: Colors.black38),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                      ),
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "No.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "Name",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "Description",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "datetime",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...List.generate(records.length, (index) {
                                      DocumentSnapshot record = records[index];
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  Text((index + 1).toString()),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(record['name']),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  Text(record['description']),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(record['datetime']),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    statusNavigation.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AnimatedStatus(
                        isActive: selectedIndex == index,
                        iconData: statusNavigation[index]['icon'] as IconData,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedStatus extends StatelessWidget {
  const AnimatedStatus({
    super.key,
    required this.iconData,
    required this.isActive,
  });

  final IconData iconData;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),
      child: Icon(
        iconData,
        size: 32,
        color: isActive ? Colors.blue : Colors.blue,
      ),
    );
  }
}
