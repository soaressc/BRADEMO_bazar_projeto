import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  //variavel para controlar o item selecionado
  final int selectedIndex;
  //função que será chamada quando o item for clicado
  final Function(int) onTap;

  //construtor
  const BottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //define qual é o item selecionado
      currentIndex: selectedIndex,
      //cor do item selecionado
      selectedItemColor: Colors.deepPurple,
      //cor do item não selecionado
      unselectedItemColor: Colors.grey,
      //faz com que os itens fiquem fixados
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      //uma lista para os botões
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Category'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
