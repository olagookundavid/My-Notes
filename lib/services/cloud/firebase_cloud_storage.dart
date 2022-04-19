import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebasecloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  // Stream<Iterable<CloudNote>> allNote({})

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                    documentId: doc.id,
                    ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                    text: doc.data()[textFieldName] as String);
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException;
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  static final FirebasecloudStorage _shared =
      FirebasecloudStorage._sharedInstance();
  FirebasecloudStorage._sharedInstance();
  factory FirebasecloudStorage() => _shared;
}
