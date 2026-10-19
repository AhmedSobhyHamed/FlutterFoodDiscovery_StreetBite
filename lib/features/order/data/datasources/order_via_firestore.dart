import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/data/datasources/order_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/entities/order_line_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/l10n/order_locale.dart';

class OrderViaFirestore implements OrderRemoteInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> create(List<OrderLineEntity> items) async {
    final user = _auth.currentUser;
    if (user == null || items.isEmpty) {
      throw GeneralException(message: OrderLocale.orderFailed);
    }
    try {
      await _firestore.collection('orders').add({
        'userId': user.uid,
        'items': [
          for (final item in items)
            {
              'mealId': item.mealId,
              'quantity': item.quantity,
            },
        ],
      });
    } on FirebaseException {
      throw GeneralException(message: OrderLocale.orderFailed);
    }
  }
}
