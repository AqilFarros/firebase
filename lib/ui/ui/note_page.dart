part of '../pages.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _firebaseServie = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  void _addNote() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      return null;
    } else {
      await _firebaseServie.addNote(
        _titleController.text,
        _contentController.text,
        _imageUrlController.text,
      );
    }
  }

  void _updateNote(
      String noteId, String title, String content, String imageUrl) async {
    _titleController.text = title;
    _contentController.text = content;
    _imageUrlController.text = imageUrl;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firebaseServie.updateNote(
                      noteId,
                      _titleController.text,
                      _contentController.text,
                      _imageUrlController.text);
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
            title: Text('Update Note $title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          );
        });
  }

  void _deleteNote(String noteId) async {
    await _firebaseServie.deleteNote(noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Page"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    _addNote();
                  },
                  child: const Text('Save Note'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firebaseServie.getNotes(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No notes found."),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]['title']),
                          subtitle: Text(
                            snapshot.data!.docs[index]['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Image.network(
                            snapshot.data!.docs[index]['image_url'],
                            width: 50,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _updateNote(
                                    snapshot.data!.docs[index].id,
                                    snapshot.data!.docs[index]['title'],
                                    snapshot.data!.docs[index]['content'],
                                    snapshot.data!.docs[index]['image_url'],
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.amber,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteNote(snapshot.data!.docs[index].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
