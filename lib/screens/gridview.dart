import 'package:flutter/material.dart';
import '../models/book.dart';

class GridViewBooks extends StatelessWidget {
  final List<Book> books;
  const GridViewBooks({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    final double itemAltura = tamanho.height / 3;
    final double itemLargura = tamanho.width / 2;

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: itemLargura / itemAltura,
      children: List.generate(books.length, (index) {
        final book = books[index];
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //deixando as imagens com bordas arredondadas
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                //adicionando as imagens
                child: Image.asset(
                  book.caminhoImagem,
                  height: itemAltura / 1.5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              //adicionando o titulo
              Text(
                book.titulo,
              ),
              //adicionando o preco
              Text(
                book.preco,
                style: const TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
