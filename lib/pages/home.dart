import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 3),
    Band(id: '3', name: 'Guns N Roses', votes: 4),
    Band(id: '4', name: 'The Beatles', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // // Remove the band from the list
        // setState(() {
        //   bands.removeWhere((b) => b.id == band.id);
        // });

        // TODO: llamar el borrado en el servidor

        // Show a snackbar to confirm deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${band.name} deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: () {
          print('${band.name} was clicked!');
        },
      ),
    );
  }

  addNewBand() {
    final TextEditingController textController = TextEditingController();

    if (Platform.isIOS) {
      // Android
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(controller: textController),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                textColor: Colors.deepPurple,
                onPressed: () {
                  addBandToList(textController.text);
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    } else if (Platform.isAndroid) {
      // iOS
      return // iOS
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(controller: textController),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  addBandToList(textController.text);
                },
                child: Text('Add'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      final newBand = Band(id: DateTime.now().toString(), name: name);
      setState(() {
        bands.add(newBand);
      });
    }
    Navigator.pop(context); // Close the dialog after adding the band
  }
}
