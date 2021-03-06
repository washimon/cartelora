import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:cartelora/src/providers/movie_provider.dart';
import 'package:cartelora/src/models/movie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0.0,
        title: Text(
          'Cartelora',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.amber), 
            onPressed: () {}
          )
        ],
      ),
      body: Column(
        children: [
          SwiperMovies(),
          MovieCategories()
        ],
      )
    );
  }
}

class MovieCategories extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Populares',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => _ProviderModel(),
          child: SwiperMoviesByCategorie()
        ),
      ],
    );
  }
}

class SwiperMoviesByCategorie extends StatefulWidget {

  @override
  _SwiperMoviesByCategorieState createState() => _SwiperMoviesByCategorieState();
}

class _SwiperMoviesByCategorieState extends State<SwiperMoviesByCategorie> {

  final MovieProvider provider = MovieProvider();

  @override
  void initState() {
    super.initState();
    provider.getPopular();
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<_ProviderModel>(context).provider = this.provider;

    return StreamBuilder(
      stream: provider.popularStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        
        final List<Movie> movies = snapshot.data;
        final screenSize = MediaQuery.of(context).size;

        if (snapshot.hasData) {
          if (movies.length == 0) return Center(child: Text('Algo salió mal'));
          
          return _CategorieCards(movies: movies);
        } else {
          return Container(
            alignment: Alignment.center,
            child: RefreshProgressIndicator(),
            height: screenSize.height * 0.2,
          );
        }
      }
    );
  }
}

class _CategorieCards extends StatefulWidget {

  final List<Movie> movies;

  _CategorieCards({
    @required this.movies
  });

  @override
  __CategorieCardsState createState() => __CategorieCardsState();
}

class __CategorieCardsState extends State<_CategorieCards> {

  PageController _pageController = PageController(
    viewportFraction: 0.34,
    initialPage: 1
  );

  @override
  void dispose() { 
    super.dispose();
    _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final provider = Provider.of<_ProviderModel>(context).provider;
    
    return Builder(
      builder: (BuildContext context) {
        _pageController.addListener(() {
          if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200.0) {
              provider.getPopular();
          }
        });
        return _Card2(screenSize: screenSize, pageController: _pageController, widget: widget);
      },
    );
  }
}

class _Card2 extends StatelessWidget {
  const _Card2({
    Key key,
    @required this.screenSize,
    @required PageController pageController,
    @required this.widget,
  }) : _pageController = pageController, super(key: key);

  final Size screenSize;
  final PageController _pageController;
  final _CategorieCards widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: screenSize.height * 0.26,
      color: Colors.amber,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.movies.length,
        pageSnapping: false,
        itemBuilder: (BuildContext context, int index) {

          final movie = widget.movies[index];
          movie.uniqueId = 'ui${movie.id}';

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  height: screenSize.height * 0.2,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'movie', arguments: movie),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/img/dots-loading.gif'),
                        image: NetworkImage(widget.movies[index].getPosterPath()),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),
                Text(
                  widget.movies[index].title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SwiperMovies extends StatelessWidget {
  
  final MovieProvider provider = MovieProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: provider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        
        final List<Movie> movies = snapshot.data;
        final screenSize = MediaQuery.of(context).size;

        if (snapshot.hasData) {
          if (movies.length == 0) return Center(child: Text('Algo salió mal'));
          
          return _MovieCards(movies: movies);
        } else {
          return Container(
            alignment: Alignment.center,
            child: RefreshProgressIndicator(),
            height: screenSize.height * 0.45,
          );
        }
      }
    );
  }
}

class _MovieCards extends StatelessWidget {

  final List<Movie> movies;

  _MovieCards({
    @required this.movies
  });

  @override
  Widget build(BuildContext context) {
    
    final screenSize = MediaQuery.of(context).size;
    
    return Container(
      padding: EdgeInsets.only(top: screenSize.height * 0.01),
      height: screenSize.height * 0.5,
      width: screenSize.width,
      // color: Colors.amber,
      child: Swiper(
        itemCount: movies.length,
        itemWidth: screenSize.width * 0.7,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {

          final String urlImg = movies[index].getPosterPath();
          movies[index].uniqueId = 'ui${movies[index].id}';
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'movie', arguments: movies[index]),
            child: Hero(
              tag: movies[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/dots-loading.gif'),
                  image: NetworkImage(urlImg),
                  fit: BoxFit.cover,
                  fadeOutDuration: Duration(milliseconds: 250),
                  fadeInDuration: Duration(milliseconds: 250),
                  fadeInCurve: Curves.fastLinearToSlowEaseIn,
                  fadeOutCurve: Curves.fastLinearToSlowEaseIn
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class _ProviderModel extends ChangeNotifier {
  
  MovieProvider _provider;

  MovieProvider get provider => this._provider;
  set provider(MovieProvider provider) {
    this._provider = provider;
  }
}