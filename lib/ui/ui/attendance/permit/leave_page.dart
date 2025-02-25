part of '../../../pages.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String strAddress = '';
  String strDate = '';
  String strTime = '';
  String strDateTime = '';
  int dateHour = 0;
  int dateMinute = 0;
  double dLat = 0.0;
  double dLong = 0.0;
  final nameController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  String dropValueCategories = "Please Choose";
  List<String> categoryList = <String>[
    'Please Choose',
    "Sick",
    "Permission",
    "Other",
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  Future<void> fetchUser() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

    if (userId == 'Unknown') {
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      String firstName = userDoc["first_name"];
      String lastName = userDoc["last_name"];
      String fullName = "$firstName $lastName";

      setState(() {
        nameController.text = fullName;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text("Please wait..."),
          ),
        ],
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Page"),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.home_filled,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Please fill the form below",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Your Name",
                      hintText: "Please enter your name",
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      labelStyle:
                          const TextStyle(fontSize: 14, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Leave Type"),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: DropdownButton(
                      value: dropValueCategories,
                      items: categoryList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          dropValueCategories = value.toString();
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text("From"),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: fromController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text("Until"),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: toController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
