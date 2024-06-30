import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:notes_app/sql.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  File? image;
  String data64 = '';
  final imagepicker = ImagePicker();

  Ucamera() async {
    var pickedimage = await imagepicker.pickImage(source: ImageSource.camera);
    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
      });
      final bytes = await image!.readAsBytes();
      data64 = base64Encode(bytes);
    }
  }

  Ugallery() async {
    var pickedimage = await imagepicker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
      });
    } else {}
  }

  SqlDb sqldb = SqlDb();
  GlobalKey<FormState> fs = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.orange),
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                showBS();
              },
              padding: EdgeInsets.all(15),
              icon: Icon(Icons.camera_alt),
              color: Colors.orange,
              iconSize: 25,
            ),
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 6),
                onPressed: () async {
                  if (note.text.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog
                          (
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              side: BorderSide(color: Colors.orange, width: 2),
                            ),
                            backgroundColor: Colors.black,
                            title: Center(
                                child: Text(
                              "!!!",
                              style: TextStyle(color: Colors.orange),
                            )),
                            content: Text(
                              " You Must Type One Character At Least To Save Note",
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          );
                        });
                  } else {
                    String sql;
                    if (data64 != '') {
                      sql = ''' 
                    
                      INSERT INTO notes (note,title,image)
                      VALUES ("${note.text}","${title.text}","${data64}")
                        
                        
                    ''';
                      Navigator.of(context).pushNamed("Home");
                    } else {
                      sql = ''' 
                    
                      INSERT INTO notes (note,title)
                      VALUES ("${note.text}","${title.text}")
                        
                        
                    ''';
                    }
                    int response = await sqldb.insertData(sql);
                    Navigator.of(context).pushNamed("Home");
                  }
                },
                icon: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.orange,
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/3.png"), fit: BoxFit.cover)),
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Form(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: title,
                      maxLength: 30,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: "Title...",
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: note,
                      maxLines: 30,
                      maxLength: 2000,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: "Start Typing....",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              )),
             
            ],
          ),
        ));
  }

  showBS() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.all(20),
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add your Image",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.photo,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: Ugallery,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Choose from Gallery",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: Ucamera,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Choose from Camera",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
