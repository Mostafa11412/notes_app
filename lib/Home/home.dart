import 'package:flutter/material.dart';
import 'package:notes_app/logic/edit.dart';
import 'package:notes_app/sql.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  bool isloading = true;

  List notes = [];
  List foundN = [];

  Future readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    notes.addAll(response);
    foundN = notes;
    isloading = false;

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  runFilter(String query) {
    List result;
    if (query.isEmpty) {
      result = notes;
    } else {
      result = notes
          .where((element) => element['title'].isEmpty
              ? element['note'].toLowerCase().contains(query.toLowerCase())
              : element['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      foundN = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("Add");
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: runFilter,
                decoration: InputDecoration(
                  label: Text("Search"),
                  suffixIconColor: Colors.orange,
                  suffixIcon: Icon(Icons.search_off),
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.orange, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.orange, width: 1)),
                ),
              ),
            ),
            isloading == true
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Container(
                      child: notes.isEmpty
                          ? Center(
                              child: Text(
                              "There is No Notes Yet",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ))
                          : ListView.builder(
                              itemCount: foundN.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                int n;
                                if ((foundN[i]['note'].length / 2).round() >
                                    20) {
                                  n = 50;
                                } else {
                                  n = (foundN[i]['note'].length / 2).round();
                                }
                                int n2;
                                if ((foundN[i]['note'].length / 3).round() >
                                    20) {
                                  n2 = 15;
                                } else {
                                  n2 = (foundN[i]['note'].length / 3).round();
                                }
                                ;

                                String tit = foundN[i]['title'].isEmpty
                                    ? foundN[i]['note'].substring(0, n2)
                                    : foundN[i]['title'];

                                String not =
                                    foundN[i]['note'].substring(0, n) + '...';

                                return Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(185, 43, 43, 41),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => Edit(
                                          note: notes[i]['note'],
                                          title: notes[i]['title'],
                                          ima: notes[i]['image'],
                                          id: notes[i]['id'],
                                        ),
                                      ));
                                    },
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 0, 20),
                                    title: Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                                      child: Text(
                                        "${tit}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    subtitle: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${not}",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 25, 10),
                                      child: IconButton(
                                        onPressed: () async {
                                          int response = await sqlDb.deleteData(
                                            "DELETE FROM notes WHERE id = ${notes[i]['id']}",
                                          );
                                          if (response > 0) {
                                            notes.removeWhere((element) =>
                                                element['id'] ==
                                                notes[i]['id']);
                                            setState(() {});
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.orange,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.close))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("d");
  }
}
