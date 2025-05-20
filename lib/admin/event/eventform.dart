import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _speakerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _imageURLController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter image URL'
                            : null,
              ),
              TextFormField(
                controller: _speakerController,
                decoration: InputDecoration(labelText: 'Speaker'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter speaker' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter location'
                            : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter time' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter description'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(_titleController.text)
                        .set({
                          'title': _titleController.text,
                          'imageURL': _imageURLController.text,
                          'speaker': _speakerController.text,
                          'location': _locationController.text,
                          'time': _timeController.text,
                          'date': _dateController.text,
                          'description': _descriptionController.text,
                        })
                        .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Event added successfully!'),
                            ),
                          );
                          _formKey.currentState!.reset();
                          _titleController.clear();
                          _imageURLController.clear();
                          _speakerController.clear();
                          _locationController.clear();
                          _timeController.clear();
                          _dateController.clear();
                          _descriptionController.clear();
                        })
                        .catchError((error) {
                          print('error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add event: $error'),
                            ),
                          );
                        });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
