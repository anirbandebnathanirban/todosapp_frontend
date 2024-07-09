import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/supervisor/supervisor.dart';
import '../models/supervisor/supervisor_name.dart';
import '../widgets/add_secondary_email.dart';
import '../widgets/add_contact_number.dart';
import '../provider/supervisor_provider.dart';

class AddSupervisorScreen extends StatefulWidget {
  @override
  _AddSupervisorScreenState createState() => _AddSupervisorScreenState();
}

class _AddSupervisorScreenState extends State<AddSupervisorScreen> {
  String supervisorFirstName = '';
  String supervisorMiddleName = '';
  String supervisorLastName = '';
  String supervisorPrimaryEmail = '';

  List<AddSecondaryEmail> secondaryEmailFormList = [AddSecondaryEmail()];
  List<String> supervisorSecondaryEmails = [];

  List<AddContactNumber> contactNumberFormList = [AddContactNumber()];
  List<String> supervisorContactNumber = [];

  void _addSupervisor(BuildContext context) {
    if (supervisorFirstName.isEmpty ||
        supervisorLastName.isEmpty ||
        supervisorPrimaryEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter both Supervisor First Name and Last Name and Primary Email'),
        ),
      );
    } else {
      Provider.of<SupervisorProvider>(context).addSupervisor(Supervisor(
        supervisorName: Supervisorname(
          supervisorFirstName: supervisorFirstName,
          supervisorMiddleName: supervisorMiddleName,
          supervisorLastName: supervisorLastName,
        ),
        supervisorPrimaryEmail: supervisorPrimaryEmail,
        supervisorSecondaryEmails: supervisorSecondaryEmails,
        supervisorContactNumber: supervisorContactNumber,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supervisor'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          TextFormField(
            onChanged: (value) {
              supervisorFirstName = value;
            },
            controller: TextEditingController(text: supervisorFirstName),
            decoration: const InputDecoration(
                icon: Icon(Icons.person, color: Colors.blueAccent),
                label: Text('Supervisor First Name',
                    style: TextStyle(color: Colors.blueAccent))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Supervisor First Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              supervisorMiddleName = value;
            },
            controller: TextEditingController(text: supervisorMiddleName),
            decoration: const InputDecoration(
                icon: Icon(Icons.person, color: Colors.blueAccent),
                label: Text('Supervisor Middle Name',
                    style: TextStyle(color: Colors.blueAccent))),
          ),
          TextFormField(
            onChanged: (value) {
              supervisorLastName = value;
            },
            controller: TextEditingController(text: supervisorLastName),
            decoration: const InputDecoration(
                icon: Icon(Icons.person, color: Colors.blueAccent),
                label: Text('Supervisor Last Name',
                    style: TextStyle(color: Colors.blueAccent))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Supervisor Last Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            onChanged: (value) {
              supervisorPrimaryEmail = value;
            },
            controller: TextEditingController(text: supervisorPrimaryEmail),
            decoration: const InputDecoration(
              icon: Icon(Icons.email, color: Colors.blueAccent),
              label: Text('Primary Email',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Primary Email is required';
              }
              String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
              if (!RegExp(emailRegex).hasMatch(value))
                return 'Enter a valid email address';
              return null;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: () {
                    setState(() {
                      secondaryEmailFormList.add(AddSecondaryEmail());
                    });
                  },
                  icon: const Icon(Icons.add_box, color: Colors.blueAccent),
                  label: const Text('Add Secondary Email',
                      style: TextStyle(color: Colors.blueAccent))),
              ListView.builder(
                  itemCount: secondaryEmailFormList.length,
                  itemBuilder: (context, index) {
                    return secondaryEmailFormList[index];
                  }),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    contactNumberFormList.add(AddContactNumber());
                  });
                },
                icon: const Icon(Icons.add_box, color: Colors.blueAccent),
                label: const Text('Add Contact Number',
                    style: TextStyle(color: Colors.blueAccent)),
              ),
              ListView.builder(
                  itemCount: contactNumberFormList.length,
                  itemBuilder: (context, index) {
                    return contactNumberFormList[index];
                  })
            ],
          ),
          TextButton.icon(
            onPressed: () {
              for (AddSecondaryEmail secondaryEmail in secondaryEmailFormList) {
                supervisorSecondaryEmails.add(secondaryEmail.secondaryEmail);
              }
              for (AddContactNumber contactNumber in contactNumberFormList) {
                supervisorContactNumber.add(contactNumber.contactNumber);
              }
              _addSupervisor(context);
            },
            icon: const Icon(Icons.person, color: Colors.blueAccent),
            label: const Text('Add Supervisor',
                style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }
}
