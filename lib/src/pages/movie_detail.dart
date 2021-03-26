import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/actores_model.dart';
import 'package:peliculas_app/src/models/pelicula_model.dart';
import 'package:peliculas_app/src/providers/pelicula_provider.dart';

class MovieDetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20,),
              _posterTitulo(context ,pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]),
          ),
        ],
      ),
    );
  }

  _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      expandedHeight: 200.0,
      backgroundColor: Colors.indigo,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title, style: TextStyle(fontSize: 16),),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/loading.gif'),
          fadeInDuration: Duration(milliseconds: 500),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(image: NetworkImage(pelicula.getPosterImg()), height: 150,),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                SizedBox(height: 5),
                Text('Popularidad:   ${pelicula.popularity.toString()}', style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                SizedBox(height: 5),
                Text('Lenguaje Original:   ${pelicula.originalLanguage}', style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
                SizedBox(height: 5),
                Text('Fecha de lanzamiento:   ${pelicula.releaseDate}', style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis,),
              ],
            ),
          )
        ],
      ),
    );
  }

  _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(pelicula.overview, textAlign: TextAlign.justify,),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculaProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliculaProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.getFoto()),
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}