import 'package:flutter/material.dart';
import 'package:sqlflutter_app/db/dbContext.dart';
import 'package:sqlflutter_app/models/work_record_model.dart';

import 'new_work_record_screen.dart';


class WorkRecordDetails extends StatefulWidget { 
  final int workRecordId;
  const WorkRecordDetails({ required this.workRecordId , Key? key }) : super(key: key);

  @override
  State<WorkRecordDetails> createState() => _WorkRecordDetailsState(workRecordId);
}

class _WorkRecordDetailsState extends State<WorkRecordDetails> {
  final int workRecordId;
  late WorkRecord workRecord;
  bool isLoading = false;

  _WorkRecordDetailsState(this.workRecordId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshWorkRecord();
  }

  Future refreshWorkRecord() async{
    setState(() {
      isLoading = true;
    });

    this.workRecord = await SqlDbContext.instance.read(widget.workRecordId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details"),
        actions: [editButton() , deleteButton()],
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              workRecord.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              workRecord.description,
              style: TextStyle(
                color: Colors.black,
              ),
            )

          ],
        ),
      )
    );
  }

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete, color: Colors.white,),
    onPressed: () async{
      await SqlDbContext.instance.delete(widget.workRecordId);

      Navigator.pop(context);
    },
  );

  Widget editButton() => IconButton(
    icon: Icon(Icons.edit_outlined),
    onPressed: () async{
      if(isLoading) return;

      await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNewWorkRecordScreen(workRecord: workRecord)));


      refreshWorkRecord();
    },
  );
}