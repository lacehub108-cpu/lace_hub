import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lace_model.dart';
import '../models/inquiry_model.dart';
import '../models/order_model.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // LACES
  static Future<void> addLace(LaceModel lace) async {
    await _db.collection('laces').doc(lace.id).set(lace.toJson());
  }
  static Future<void> updateLace(LaceModel lace) async {
    await _db.collection('laces').doc(lace.id).update(lace.toJson());
  }
  static Stream<List<LaceModel>> getLacesStream() {
    return _db.collection('laces').orderBy('id', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => LaceModel.fromJson(doc.data())).toList(),
    );
  }
  static Future<void> deleteLace(String id) async {
    await _db.collection('laces').doc(id).delete();
  }

  // INQUIRY (Admin)
  static Future<void> addInquiry(InquiryModel inquiry) async {
    await _db.collection('inquiries').doc(inquiry.id).set(inquiry.toJson());
  }
  static Stream<List<InquiryModel>> getInquiriesStream() {
    return _db.collection('inquiries').orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => InquiryModel.fromJson(doc.data())).toList(),
    );
  }
  static Future<void> updateInquiryStatus(String id, String status) async {
    await _db.collection('inquiries').doc(id).update({'status': status});
  }
  static Future<void> markInquiryRead(String id) async {
    await _db.collection('inquiries').doc(id).update({'isRead': true});
  }
  static Future<void> deleteInquiry(String id) async {
    await _db.collection('inquiries').doc(id).delete();
  }

  // INQUIRY (Customer - Filtered)
  static Stream<List<InquiryModel>> getCustomerInquiriesStream(String customerId) {
    return _db.collection('inquiries')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => InquiryModel.fromJson(doc.data())).toList());
  }

  // ORDER (Admin)
  static Future<void> addOrder(OrderModel order) async {
    await _db.collection('orders').doc(order.id).set(order.toJson());
  }
  static Stream<List<OrderModel>> getOrdersStream() {
    return _db.collection('orders').orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList(),
    );
  }
  static Future<void> updateOrderStatus(String id, String status) async {
    await _db.collection('orders').doc(id).update({'status': status});
  }
  static Future<void> markOrderRead(String id) async {
    await _db.collection('orders').doc(id).update({'isRead': true});
  }
  static Future<void> deleteOrder(String id) async {
    await _db.collection('orders').doc(id).delete();
  }

  // ORDER (Customer - Filtered)
  static Stream<List<OrderModel>> getCustomerOrdersStream(String customerId) {
    return _db.collection('orders')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
  }
}