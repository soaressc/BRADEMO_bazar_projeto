// Cart Repository
import 'package:myapp/models/cart.dart';
import 'package:myapp/service/cart_service.dart';

class CartRepository {
  final CartService cartService;

  CartRepository({required this.cartService});

  Future<void> addCart(Cart cart) => cartService.createCart(cart);
  Future<Cart?> fetchCart(String id) => cartService.getCart(id);
  Future<void> updateCart(Cart cart) => cartService.updateCart(cart);
  Future<void> removeCart(String id) => cartService.deleteCart(id);
}
