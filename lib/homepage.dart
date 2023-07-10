import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/item_mode.dart';
import 'package:todolist/provider/listprovider.dart';

class Todolist extends ConsumerStatefulWidget {
  const Todolist({super.key});
  @override
  ConsumerState<Todolist> createState() {
    return _TodolistState();
  }
}

class _TodolistState extends ConsumerState<Todolist> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var boolval = false;
  // bool _isDataFetched = false;
  late Future<void> userlist;
  @override
  void initState() {
    super.initState();
    userlist = ref.read(listProvider.notifier).getList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  void addButton() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Enter New Item'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Enter the Name of Item'),
                validator: (value) {
                  if (_nameController.text.isEmpty) {
                    return '_nameController can\'t be empty';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _nameController.text = newValue!;
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      // print('hello');
                      ref.watch(listProvider.notifier).addtoList(ItemModel(
                          name: _nameController.text, isChecked: boolval));
                      _nameController.clear();
                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  },
                  child: const Text('Save'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final list = ref.watch(listProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('To do list '),
        ),
        body: FutureBuilder(
          future: userlist,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(list[index]),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  // dismissThresholds:const <DismissDirection, double>{},
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (DismissDirection.endToStart == direction) {
                      setState(() {
                        ref
                            .watch(listProvider.notifier)
                            .deleteItem(list[index]);
                      });
                      // ScaffoldMessenger.of(context).clearSnackBars();
                      // ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
                      //   content:
                      //       Text('${list[index].name} is removed from list'),
                      //   action: SnackBarAction(label: 'Undo', onPressed: () {

                      //   }),
                      // ));
                    }
                  },
                  child: Card(
                    // height: 100,
                    // alignment: Alignment.center,
                    elevation: 5,
                    // shadowColor: Colors.black,
                    child: ListTile(
                      leading: Checkbox(
                          value: list[index].isChecked,
                          onChanged: (value) {
                            setState(() {
                              list[index].isChecked = value!;
                              boolval = list[index].isChecked;
                            });
                          }),
                      trailing: const Icon(Icons.abc),
                      title: Text(list[index].name),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: IconButton(
          onPressed: addButton,
          icon: const Icon(Icons.add),
        ));
  }
}
