import 'package:flutter/material.dart';
import 'package:sqlflutter_app/db/dbContext.dart';
import 'package:sqlflutter_app/models/work_record_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqlflutter_app/screen/work_record_details.dart';

import '../wigets/work_record_card.dart';
import 'new_work_record_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<WorkRecord> workRecords;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshWorkRecord();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SqlDbContext.instance.close();
    super.dispose();
  }

  Future refreshWorkRecord() async {
    setState(() {
      isLoading = true;
    });

    this.workRecords = await SqlDbContext.instance.readAll();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WorkRecords",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : workRecords.isEmpty
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "No Work Records",
                      style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                    ),
                )
                : buildWorkRecord(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add , color: Colors.black,),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNewWorkRecordScreen()));
          refreshWorkRecord();
        },
      ),
    );
  }

  Widget buildWorkRecord() => MasonryGridView.count(
        itemCount: workRecords.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final workrecord = workRecords[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WorkRecordDetails(workRecordId: workrecord.id!)));
              refreshWorkRecord();
            },
            child: Card(
              color: Colors.blue,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(workrecord.title , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 10,),
                    Text(workrecord.description , style: TextStyle(color: Colors.black ),),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
