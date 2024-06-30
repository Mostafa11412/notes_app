import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:notes_app/sql.dart';
import 'dart:typed_data';

class Edit extends StatefulWidget {
  final note;
  final title;
  final ima;
  final id;

  const Edit({
    super.key,
    es,
    this.note,
    this.title,
    this.ima,
    this.id,
  });

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  SqlDb sqldb = SqlDb();
  GlobalKey<FormState> fs = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  File? image;
  String data64 = '';
  Uint8List? imageBytes;

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    if (widget.ima != null) {
      data64 = widget.ima;
    }
    if (data64 != '') {
      final bytes = base64Decode(data64);
      setState(() {
        imageBytes = Uint8List.fromList(bytes);
      });
    }

    super.initState();
  }

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
              onPressed: () {},
              padding: EdgeInsets.all(15),
              icon: Icon(Icons.camera_alt),
              color: Colors.orange,
              iconSize: 25,
            ),
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 6),
                onPressed: () async {
                  int response = await sqldb.updateData(''' 
                    
                      UPDATE notes SET 
                      note = "${note.text}", 
                      title = "${title.text}"
                      WHERE id = ${widget.id}
                  
                      
                        
                        
                    ''');
                  Navigator.of(context).pushNamed("Home");
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
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: "  Title...",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                        hintText: "  Start Typing....",
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
}
