import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guestbook/route/route.dart' as route;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

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
          'created': FieldValue.serverTimestamp(),
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
        title: const FlutterLogo(
          size: 54,
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
      body: Column(
        children: [
          if (sizeHeight >
              800) //if state to show carousel if certain media height
            CarouselSlider(
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 300.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn),
              items: [
                Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
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
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: AssetImage('assets/images/business.jpg'),
                          fit: BoxFit.fitHeight,
                        ))),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: AssetImage('assets/images/nursing.jpg'),
                          fit: BoxFit.cover,
                        ))),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: AssetImage('assets/images/software.jpg'),
                          fit: BoxFit.cover,
                        ))),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: AssetImage('assets/images/engineer.jpg'),
                          fit: BoxFit.cover,
                        ))),
              ],
            ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 2,
                  offset: Offset(1, 1), // Shadow position
                ),
              ],
            ),
            height: 70,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.history_edu,
                size: 53,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Text('RDP Guestbook',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ))
            ]),
          ),
          Center(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('guests') // 👈 Your desired collection name here
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              return SizedBox(
                height: 350,
                child: ListView(
                    scrollDirection: Axis
                        .vertical, //This makes the listview scrollable in a sizexbox
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Text(data['guest_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Text(
                                      data['message'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          background: Paint()
                                            ..color =
                                                Colors.blue.withOpacity(0.5)
                                            ..strokeWidth = 30
                                            ..style = PaintingStyle.stroke
                                            ..strokeJoin = StrokeJoin.round
                                            ..strokeCap = StrokeCap.round),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.format_quote,
                                  size: 34, color: Colors.blue),
                            ],
                          ),
                        ), // 👈 Your valid data here
                      );
                    }).toList()),
              );
            },
          ))
        ],
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
                  shape: RoundedRectangleBorder(
                    //Adding borderradiusto AlertDialog
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 45,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Leave a Message',
                            style: TextStyle(fontSize: 28, color: Colors.blue))
                      ]),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(
                                    12), //Limit length of name input
                              ],
                              controller: myController1,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              maxLines: 6,
                              controller: myController2,
                              decoration: InputDecoration(
                                focusColor: Colors.white,
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
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview, color: Colors.blue),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview, color: Colors.blue),
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

//Shows Alertdialog when the info button is pressed in the appBar
showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Info"),
    content: Text(
        "This was app developed in the Mobile App Development course.  It connects to a Firebase Firestore back-end and uses Firebase Auth for authentication."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
