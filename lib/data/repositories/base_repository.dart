import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/repository_interfaces.dart';

/// Base Repository with common Firestore operations
abstract class BaseRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionPath;

  BaseRepository({required this.firestore, required this.collectionPath});

  /// Get collection reference
  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection(collectionPath);

  /// Convert Firestore document to model
  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);

  /// Convert model to Firestore data
  Map<String, dynamic> toFirestore(T item);

  /// Get all documents
  Future<Result<List<T>>> getAll() async {
    try {
      final snapshot = await collection.get();
      final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(items);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get all documents: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Get document by ID
  Future<Result<T>> getById(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (!doc.exists) {
        return Failure('Document not found', code: 'not-found');
      }
      return Success(fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get document: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Create new document
  Future<Result<T>> create(T item) async {
    try {
      final data = toFirestore(item);
      final docRef = await collection.add(data);
      final doc = await docRef.get();
      return Success(fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to create document: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Create document with custom ID
  Future<Result<T>> createWithId(String id, T item) async {
    try {
      final data = toFirestore(item);
      await collection.doc(id).set(data);
      final doc = await collection.doc(id).get();
      return Success(fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to create document: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Update existing document
  Future<Result<T>> update(String id, T item) async {
    try {
      final data = toFirestore(item);
      await collection.doc(id).update(data);
      final doc = await collection.doc(id).get();
      return Success(fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to update document: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Partial update with specific fields
  Future<Result<T>> updateFields(String id, Map<String, dynamic> fields) async {
    try {
      await collection.doc(id).update(fields);
      final doc = await collection.doc(id).get();
      return Success(fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to update fields: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Delete document
  Future<Result<void>> delete(String id) async {
    try {
      await collection.doc(id).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to delete document: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Stream of all documents (real-time)
  Stream<Result<List<T>>> watchAll() {
    try {
      return collection.snapshots().map((snapshot) {
        try {
          final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
          return Success(items);
        } catch (e) {
          return Failure(
            'Error processing snapshot: $e',
            exception: e as Exception?,
          );
        }
      });
    } catch (e) {
      return Stream.value(
        Failure('Failed to watch documents: $e', exception: e as Exception?),
      );
    }
  }

  /// Stream of single document (real-time)
  Stream<Result<T>> watchById(String id) {
    try {
      return collection.doc(id).snapshots().map((doc) {
        try {
          if (!doc.exists) {
            return Failure('Document not found', code: 'not-found');
          }
          return Success(fromFirestore(doc));
        } catch (e) {
          return Failure(
            'Error processing snapshot: $e',
            exception: e as Exception?,
          );
        }
      });
    } catch (e) {
      return Stream.value(
        Failure('Failed to watch document: $e', exception: e as Exception?),
      );
    }
  }

  /// Query with where clause
  Future<Result<List<T>>> queryWhere({
    required String field,
    required dynamic value,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = collection.where(
        field,
        isEqualTo: value,
      );
      if (limit != null) {
        query = query.limit(limit);
      }
      final snapshot = await query.get();
      final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(items);
    } on FirebaseException catch (e) {
      return Failure('Query failed: ${e.message}', code: e.code, exception: e);
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Query with orderBy
  Future<Result<List<T>>> queryOrderBy({
    required String field,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = collection.orderBy(
        field,
        descending: descending,
      );
      if (limit != null) {
        query = query.limit(limit);
      }
      final snapshot = await query.get();
      final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(items);
    } on FirebaseException catch (e) {
      return Failure('Query failed: ${e.message}', code: e.code, exception: e);
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Complex query with multiple conditions
  Future<Result<List<T>>> complexQuery({
    List<QueryCondition>? conditions,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = collection;

      // Apply where conditions
      if (conditions != null) {
        for (var condition in conditions) {
          query = query.where(
            condition.field,
            isEqualTo: condition.isEqualTo,
            isNotEqualTo: condition.isNotEqualTo,
            isLessThan: condition.isLessThan,
            isLessThanOrEqualTo: condition.isLessThanOrEqualTo,
            isGreaterThan: condition.isGreaterThan,
            isGreaterThanOrEqualTo: condition.isGreaterThanOrEqualTo,
            arrayContains: condition.arrayContains,
            arrayContainsAny: condition.arrayContainsAny,
            whereIn: condition.whereIn,
            whereNotIn: condition.whereNotIn,
            isNull: condition.isNull,
          );
        }
      }

      // Apply orderBy
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      final items = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(items);
    } on FirebaseException catch (e) {
      return Failure(
        'Complex query failed: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Batch write operations
  Future<Result<void>> batchWrite(List<BatchOperation<T>> operations) async {
    try {
      final batch = firestore.batch();

      for (var operation in operations) {
        final docRef = collection.doc(operation.id);
        switch (operation.type) {
          case BatchOperationType.create:
          case BatchOperationType.set:
            batch.set(docRef, toFirestore(operation.data as T));
            break;
          case BatchOperationType.update:
            batch.update(docRef, toFirestore(operation.data as T));
            break;
          case BatchOperationType.delete:
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Batch write failed: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Run transaction
  Future<Result<R>> runTransaction<R>(
    Future<R> Function(Transaction transaction) transactionHandler,
  ) async {
    try {
      final result = await firestore.runTransaction(transactionHandler);
      return Success(result);
    } on FirebaseException catch (e) {
      return Failure(
        'Transaction failed: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Helper: Convert Timestamp to DateTime
  DateTime? timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is DateTime) {
      return timestamp;
    }
    return null;
  }

  /// Helper: Convert DateTime to Timestamp
  Timestamp? dateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }
}

/// Query condition for complex queries
class QueryCondition {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final List<dynamic>? whereNotIn;
  final bool? isNull;

  QueryCondition({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

/// Batch operation type
enum BatchOperationType { create, set, update, delete }

/// Batch operation
class BatchOperation<T> {
  final String id;
  final BatchOperationType type;
  final T? data;

  BatchOperation({required this.id, required this.type, this.data});
}
