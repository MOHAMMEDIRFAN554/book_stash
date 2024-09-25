import 'package:book_stash/service/database.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Book'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const Text(
                'Price',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: priceController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const Text(
                'Author',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12.0),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: authorController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: OutlinedButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      String id = randomAlphaNumeric(10);

                      Map<String, dynamic> bookInfoMap = {
                        "Title": titleController.text,
                        "Price": priceController.text,
                        "Author": authorController.text,
                        "Id": id,
                      };
                      await DatabaseHelper()
                          .addBookDetails(bookInfoMap, id)
                          .then((value) {
                        Message.show(
                            message: 'Book has beed added successfully');
                        Navigator.of(context).pop();
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
