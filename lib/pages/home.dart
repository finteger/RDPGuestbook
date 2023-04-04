import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guestbook/route/route.dart' as route;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference guests = FirebaseFirestore.instance.collection('guests');

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  Future<void> addGuestPost() async {
    db
        .collection('guests')
        .add({
          'guest_name': myController1.text,
          'message': myController2.text,
          'created': DateTime.now(),
        })
        .then((value) => print("Guest & message added"))
        .catchError((error) => print("Failed to add guest & message: $error"));
  }

  Future<void> getGuestPosts() async {
    db.collection("guests").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const FlutterLogo(
              size: 54,
            ),
            Text('lutter dev')
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 2, 47, 84),
            ],
          ),
        ),
        child: Column(
          children: [
            if (sizeHeight > 800)
              CarouselSlider(
                options: CarouselOptions(
                  height: 280.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                ),
                items: [
                  Stack(children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(18.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 15,
                                blurRadius: 17,
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage('assets/images/download.png'),
                              fit: BoxFit.cover,
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'When you get here, you understand.',
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: const Duration(milliseconds: 200),
                              ),
                            ],
                            totalRepeatCount: 4,
                            pause: const Duration(milliseconds: 1000),
                            displayFullTextOnTap: true,
                            stopPauseOnTap: false,
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          border:
                              Border.all(color: Colors.blue.withOpacity(.50)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/business.jpg'),
                            fit: BoxFit.fitHeight,
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          border:
                              Border.all(color: Colors.blue.withOpacity(.50)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/nursing.jpg'),
                            fit: BoxFit.cover,
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          border:
                              Border.all(color: Colors.blue.withOpacity(.50)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/software.jpg'),
                            fit: BoxFit.cover,
                          ))),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          border:
                              Border.all(color: Colors.blue.withOpacity(.50)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/engineer.jpg'),
                            fit: BoxFit.cover,
                          ))),
                ],
              ),
            if (sizeHeight > 800)
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.blue,
                      blurRadius: 2,
                      offset: Offset(1.0, 1.0))
                ]),
                height: 45,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.history_edu,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('RDP Guestbook',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))
                ]),
              ),
            Center(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('guests') // 👈 Your desired collection name here
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading...");
                }
                return Scrollbar(
                    thumbVisibility: true,
                    thickness: 8,
                    radius: Radius.circular(23),
                    child: SizedBox(
                      height: 350,
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            final firestoreTimestamp =
                                data['created'] as Timestamp;
                            final dateTime = firestoreTimestamp.toDate();
                            final timeAgo =
                                timeago.format(dateTime, locale: 'en_short');

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Text('➥' + ' ' + data['guest_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        color: Colors.white)),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      data['message'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        background: Paint()
                                          ..color = Colors.blue.withOpacity(0.3)
                                          ..strokeWidth = 30
                                          ..style = PaintingStyle.stroke
                                          ..strokeJoin = StrokeJoin.round
                                          ..strokeCap = StrokeCap.round,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.format_quote,
                                        size: 34, color: Colors.blue),
                                  ],
                                ),
                                trailing: Text(timeAgo,
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          }).toList()),
                    ));
              },
            ))
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.home, size: (36)),
                    Padding(
                      padding: const EdgeInsets.only(right: 34),
                      child: Text(
                        'Home Page',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, route.home),
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.contact_page, size: (36)),
                    Padding(
                      padding: const EdgeInsets.only(right: 34),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, route.contactUs),
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.pages_rounded, size: (36)),
                    Padding(
                      padding: const EdgeInsets.only(right: 52),
                      child: Text(
                        'About Us',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, route.aboutUs),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.lightBlue,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 45,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Leave a Message',
                            style: TextStyle(fontSize: 28, color: Colors.white))
                      ]),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(9)
                              ],
                              controller: myController1,
                              decoration: InputDecoration(
                                labelText: ' First Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(18)
                              ],
                              maxLines: 8,
                              controller: myController2,
                              decoration: InputDecoration(
                                labelText: 'Message',
                                icon: Icon(Icons.message),
                                border: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          addGuestPost();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Message sent to database!'),
                          ));
                        })
                  ],
                );
              });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview, color: Colors.white),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview, color: Colors.white),
            label: 'Contact Us',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, route.home);
              break;
            case 1:
              Navigator.pushNamed(context, route.aboutUs);
              break;
            case 2:
              Navigator.pushNamed(context, route.contactUs);
              break;
            default:
              break;
          }
        },
      ),
    );
    ;
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text('OK'),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text('Info'),
    content: Text(
        "This app was developed in the Mobile Application course.  It connect to a Firebase back-end and used Firebase Auth for authentication."),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
