import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:peliculasapp/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.20,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _tarjeta(context, peliculas[i]),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    // Solucioón antigua del video
    // pelicula.uniqueId = '${pelicula.id}-poster';
    // Solución nueva con clase UniqueKey
    pelicula.uniqueId = UniqueKey().toString();

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(children: [
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(
                pelicula.getPosterImg(),
              ),
              fit: BoxFit.cover,
              height: 140.0,
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        )
      ]),
    );

    return GestureDetector(
      onTap: () {
        // timeDilation = 2;
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }
}
