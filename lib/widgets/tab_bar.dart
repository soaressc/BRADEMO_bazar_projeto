import '../screens/home.dart';
import 'package:flutter/material.dart';
import '../screens/authors_list_screen.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({super.key});

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

//classe que define o comportamento do Tab Bar
class _TabBarSectionState extends State<TabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    //inicializa o tab controller
    _tabController = TabController(length: 2, vsync: this);

    //para detectar as mudanças de aba
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      if (_tabController.index == 1) {
        // vai para a página de Autores
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthorsListScreen()),
        );
      }
      
    });
  }

  @override
  void dispose() {
    // para os recursos do tab controller
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      //cor do texto quando selecionado
      labelColor: Colors.black,
      //cor do texto quando não selecionado
      unselectedLabelColor: Colors.grey,
      //cor do insicador
      indicatorColor: Colors.deepPurple,
      tabs: const [
        Tab(text: 'Livros'),
        Tab(text: 'Autores'),
      ],
    );
  }
}
