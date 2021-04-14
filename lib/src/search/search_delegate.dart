import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/pelicula_model.dart';
import 'package:peliculas_app/src/providers/pelicula_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas = ['colmillo', 'Balto'];
  final peliculasRecientes = ['Mi villano fav', 'misión posible'];

  @override
  List<Widget> buildActions(BuildContext context) {
      
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () { query = ''; },
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon:AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), 
        onPressed: (){ close(context, null); }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      
      return Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.blueAccent,
          child: Text(seleccion),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){
      return Container();
    } 
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder:(BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        final peliculas = snapshot.data;
        if(snapshot.hasData){
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  width: 50,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }, 
    );     

    /*final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();
    
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder:(context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      }, 
    );*/
  }

}