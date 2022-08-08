import 'package:flutter/material.dart';
import 'package:sqlflutter_app/db/dbContext.dart';
import 'package:sqlflutter_app/models/work_record_model.dart';

class AddNewWorkRecordScreen extends StatefulWidget {
  final WorkRecord? workRecord;

  const AddNewWorkRecordScreen({this.workRecord, Key? key}) : super(key: key);

  @override
  State<AddNewWorkRecordScreen> createState() => _AddNewWorkRecordScreenState();
}

class _AddNewWorkRecordScreenState extends State<AddNewWorkRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    if(widget.workRecord != null)
    {
      titleController.text = widget.workRecord!.title;
      descriptionController.text = widget.workRecord!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new record!"),
        actions: [saveButton()],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: titleController,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionController,
                  minLines: 5,
                  maxLines: null,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Description",
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveButton() => IconButton(
    icon: const Icon(Icons.save , color: Colors.white,),

    onPressed: ()async{

      if(widget.workRecord != null)
      {
        await SqlDbContext.instance.update(WorkRecord(id: widget.workRecord!.id, description: descriptionController.text, checkInType: widget.workRecord!.checkInType, title: titleController.text));
        Navigator.pop(context);
      }else{

        final workR = WorkRecord(description: descriptionController.text, checkInType: "QR", date: DateTime.now(), title: titleController.text, checkoutDate: DateTime.now());

        await SqlDbContext.instance.create(workR);
        Navigator.pop(context);
      }
    },
  );
}
