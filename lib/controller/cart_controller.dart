// Cart Controller
import 'package:myapp/models/cart.dart';
import 'package:myapp/repository/cart_repository.dart';

class CartController {
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  Future<void> createCart(Cart cart) async {
    await cartRepository.addCart(cart);
  }

  Future<Cart?> getCart(String id) async {
    return await cartRepository.fetchCart(id);
  }

  Future<void> updateCart(Cart cart) async {
    await cartRepository.updateCart(cart);
  }

  Future<void> deleteCart(String id) async {
    await cartRepository.removeCart(id);
  }
}
