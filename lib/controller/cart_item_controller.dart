import '../service/cart_item_service.dart';

class CartItemController {
  final CartItemService _service = CartItemService();

  Future<void> increaseQuantity(String cartId, String itemId) async {
    final item = await _service.getItem(cartId, itemId);
    if (item != null) {
      await _service.updateItemQuantity(cartId, itemId, item.quantity + 1);
    }
  }

  Future<void> decreaseQuantity(String cartId, String itemId) async {
    final item = await _service.getItem(cartId, itemId);
    if (item != null && item.quantity > 1) {
      await _service.updateItemQuantity(cartId, itemId, item.quantity - 1);
    }
  }
}
