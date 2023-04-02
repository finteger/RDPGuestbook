import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newproject1/route/route.dart' as route;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';

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
        .add({'guest_name': myController1.text, 'message': myController2.text})
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
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(height: 300.0),
            items: [
              Stack(children: [
                Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 15,
                        blurRadius: 17,
                        offset: Offset(0, 7), // changes position of shadow
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
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                        image: AssetImage('assets/images/business.jpg'),
                        fit: BoxFit.fitHeight,
                      ))),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                        image: AssetImage('assets/images/nursing.jpg'),
                        fit: BoxFit.cover,
                      ))),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                        image: AssetImage('assets/images/software.jpg'),
                        fit: BoxFit.cover,
                      ))),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                        image: AssetImage('assets/images/engineer.jpg'),
                        fit: BoxFit.cover,
                      ))),
            ],
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
                return const Text("Loading");
              }
              return ListView(
                  scrollDirection: Axis.vertical,
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
                        title: Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text(data['message']),
                        ), // 👈 Your valid data here
                      ),
                    );
                  }).toList());
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
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 45,
                        ),
                        Text('Leave a Message')
                      ]),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: myController1,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
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
                  actions: [
                    ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          addGuestPost();
                          Navigator.pop(context);
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
            icon: Icon(Icons.pageview),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: 'Page 2',
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
