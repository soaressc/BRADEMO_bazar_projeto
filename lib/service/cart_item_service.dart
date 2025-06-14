import '../models/cart_item.dart';
import '../repository/cart_item_repository.dart';

class CartItemService {
  final CartItemRepository _repository = CartItemRepository();

  Future<void> addOrUpdateItem(String cartId, CartItem item) async {
    if (item.id.isEmpty) {
      throw ArgumentError('Item precisa de um ID válido');
    }
    await _repository.createOrUpdate(cartId, item);
  }

  Future<void> updateItemQuantity(String cartId, String itemId, int quantity) async {
    final existingItem = await _repository.getById(cartId, itemId);
    if (existingItem != null) {
      final updated = existingItem.copyWith(quantity: quantity);
      await _repository.createOrUpdate(cartId, updated);
    }
  }

  Future<void> deleteItem(String cartId, String itemId) async {
    await _repository.delete(cartId, itemId);
  }

  Future<CartItem?> getItem(String cartId, String itemId) async {
    return await _repository.getById(cartId, itemId);
  }

  Future<List<CartItem>> getItems(String cartId) async {
    return await _repository.getAll(cartId);
  }

  Future<void> clearCart(String cartId) async {
    await _repository.clearCart(cartId);
  }
}
