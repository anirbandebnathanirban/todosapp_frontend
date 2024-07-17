import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../models/supervisor/supervisor.dart';
import '../provider/supervisor_provider.dart';

class AddSupervisor extends StatefulWidget {
  mongo.ObjectId? supervisorId;

  @override
  _AddSupervisorState createState() => _AddSupervisorState();
}

class _AddSupervisorState extends State<AddSupervisor> {
  Widget selectedSupervisor = const Text('No Supervisor Selected',
      style: TextStyle(color: Colors.blueAccent));
  Supervisor? supervisor;

  @override
  Widget build(BuildContext context) {
    List<Supervisor> supervisors =
        Provider.of<SupervisorProvider>(context, listen: false).supervisors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<Supervisor>(
          hint: const Text('Select Supervisor',
              style: TextStyle(color: Colors.blueAccent)),
          value: supervisor,
          items: supervisors
              .map<DropdownMenuItem<Supervisor>>((Supervisor supervisor) {
            return DropdownMenuItem<Supervisor>(
                value: supervisor,
                child: SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, color: Colors.blueAccent),
                      Expanded(
                          child: Text(
                              '${supervisor.supervisorName.supervisorFirstName} ${supervisor.supervisorName.supervisorLastName}',
                              style: const TextStyle(color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ));
          }).toList(),
          onChanged: (supervisor) {
            if (supervisor == null) {
              return;
            }
            setState(() {
              this.supervisor = supervisor;
              widget.supervisorId = supervisor.supervisorId;
              selectedSupervisor = ExpansionTile(
                leading: const Icon(Icons.person, color: Colors.amber),
                title: Text(
                    '${supervisor.supervisorName.supervisorFirstName} ${supervisor.supervisorName.supervisorLastName}',
                    style: const TextStyle(color: Colors.amber)),
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person,
                              color: Colors.blueAccent),
                          title: Text(
                              'FULL NAME : ${supervisor.supervisorName.supervisorFirstName} ${supervisor.supervisorName.supervisorMiddleName} ${supervisor.supervisorName.supervisorLastName}',
                              style: const TextStyle(color: Colors.blueAccent)),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.email, color: Colors.blueAccent),
                          title: Text(
                              'EMAIL : ${supervisor.supervisorPrimaryEmail}',
                              style: const TextStyle(color: Colors.blueAccent)),
                        ),
                        ExpansionTile(
                          leading:
                              const Icon(Icons.email, color: Colors.blueAccent),
                          title: const Text('SECONDARY EMAILS',
                              style: TextStyle(color: Colors.blueAccent)),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: supervisor
                                        .supervisorSecondaryEmails?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.email_sharp,
                                        color: Colors.purpleAccent),
                                    title: Text(
                                        '${index + 1}. ${supervisor.supervisorSecondaryEmails![index]}',
                                        style: const TextStyle(
                                            color: Colors.purpleAccent)),
                                  );
                                })
                          ],
                        ),
                        ExpansionTile(
                          leading:
                              const Icon(Icons.call, color: Colors.blueAccent),
                          title: const Text('CONTACT NUMBER',
                              style: TextStyle(color: Colors.blueAccent)),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: supervisor
                                        .supervisorContactNumber?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.phone_callback,
                                        color: Colors.purpleAccent),
                                    title: Text(
                                        '${index + 1}. ${supervisor.supervisorContactNumber![index]}',
                                        style: const TextStyle(
                                            color: Colors.purpleAccent)),
                                  );
                                })
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            });
          },
        ),
        selectedSupervisor,
      ],
    );
  }
}
