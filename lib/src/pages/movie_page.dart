import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cartelora/src/models/genre.dart';
import 'package:cartelora/src/models/movie.dart';
import 'package:cartelora/src/providers/movie_provider.dart';

class MoviePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
  final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                PosterAndInfoMovie(movie: movie),
                CircularVoteAndOverview(movie: movie)
              ]
            )
          )
        ],
      ),
    );
  }
}

class CircularVoteAndOverview extends StatelessWidget {

  final Movie movie;

  CircularVoteAndOverview({
    @required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      // height: screenSize.height * 0.3,
      width: screenSize.width,
      color: Colors.black12,
      child: Row(
        children: [
          CircularVote(percentage: movie.voteAverage * 10, voteCount: movie.voteCount),
          SizedBox(width: 15.0),
          Overview(movie: movie)
        ],
      ),
    );
  }
}

class Overview extends StatelessWidget {

  final Movie movie;

  Overview({
    @required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          children: [
            Text(
              'SINOPSIS',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              '${movie.overview}...',
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 1.0
              ),
              textAlign: TextAlign.justify
            ),
          ],
        ),
      ),
    );
  }
}

class CircularVote extends StatefulWidget {

  final double percentage;
  final int voteCount;

  CircularVote({
    @required this.percentage,
    @required this.voteCount
  });

  @override
  _CircularVoteState createState() => _CircularVoteState();
}

class _CircularVoteState extends State<CircularVote> with SingleTickerProviderStateMixin {

  AnimationController animonControl;
  double startPercentage = 0.0;
  double newPercentage = 0.0;

  @override
  void initState() {
    animonControl = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    animonControl.forward();
    animonControl.addListener(() {
      setState(() {
        newPercentage = lerpDouble(startPercentage, widget.percentage, animonControl.value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    animonControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: Container(
                  child: CustomPaint(
                    painter: CircleVotePainter(percentage: newPercentage)
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1/1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      newPercentage.toString().split('.')[0],
                      style: TextStyle(
                        fontSize: 31.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        // fontSize: 1.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${(newPercentage/10).toString().substring(0,3)} de\n',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w300
                  )
                ),
                TextSpan(
                  text: '${widget.voteCount} votos',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w300
                  )
                ),

              ]
            )
          )
        ],
      ),
    );
  }
}

class CircleVotePainter extends CustomPainter {

  final double percentage;
  CircleVotePainter({
    this.percentage
  });

  @override
  paint(Canvas canvas, Size size) {
    Color color = Colors.grey;
    final width = size.width;
    final height = size.height;
    // Draw Circle
    final paintCircle = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black87
      ..strokeWidth = 1.0;
    final center = Offset(width/2, height/2);
    final radius = min(width/2, height/2);
    // Draw Arc
    if (percentage >= 0 && percentage <= 39) {
      color = Colors.red;
    } else if (percentage >= 40 && percentage <= 69) {
      color = Colors.amber;
    } else {
      color = Colors.green;
    }

    final paintArc = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * (percentage / 100);
    final rect = Rect.fromCircle(center: center, radius: min(width * 0.42, height * 0.42));
    final useCenter = false;

    canvas..drawCircle(center, radius, paintCircle)
          ..drawArc(rect, startAngle, sweepAngle, useCenter, paintArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PosterAndInfoMovie extends StatelessWidget {
  
  final Movie movie;
  
  PosterAndInfoMovie({
    @required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            height: screenSize.height / 3.2,
            child: Row(
              children: [
                MovieProfilePicture(imgUrl: movie.getPosterPath(), uniqueId: movie.uniqueId),
                SizedBox(width: 15.0),
                MovieInfo(movie: movie)
              ],
            )
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {

  final Movie movie;

  CustomAppBar({
    @required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 181.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          '${movie.title} (${movie.releaseDate.year.toString().padLeft(4, '0')})',
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          children: [
            Image(
              // placeholder: AssetImage('assets/img/dots-loading.gif'),
              image: NetworkImage(movie.getBackdropPath()),
              fit: BoxFit.cover
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.2),
                    Color.fromRGBO(0, 0, 0, 0.5),
                  ],
                  stops: [
                    0.6,
                    1.0
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MovieInfo extends StatelessWidget {

  final Movie movie;
  final TextStyle myStyle1 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );
  final TextStyle myStyle2 = TextStyle(
    fontWeight: FontWeight.w300,

  );
  final MovieProvider provider = MovieProvider();
  final Set<String> genresName = Set();

  MovieInfo({
    @required this.movie
  });

  @override
  Widget build(BuildContext context) {
  String genresString = '';
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Título original',
            style: myStyle2
          ),
          Text(
            '${movie.originalTitle}',
            style: myStyle1,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis
          ),
          Divider(),
          Text(
            'Género',
            style: myStyle2
          ),
          FutureBuilder(
            future: provider.getGenres(),
            builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
              if (!snapshot.hasData) return Text('Cargando...');
              if (snapshot.data == []) return Text('Problemas de conexión');
              final genres = snapshot.data;
              movie.genreIds.forEach((genreId) {
                for (var i = 0; i < genres.length; i++) {
                  if (genreId == genres[i].id) {
                    genresName.add(genres[i].name);
                    break;
                  }
                }
              });
              genresString = '';
              genresName.forEach((name) {
                String bar = ' | ';

                if (genresName.last == name) bar = '';
                genresString += '$name$bar';
              });

              return Text(
                genresString,
                style: myStyle1,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          Divider(),
          Text(
            'Popularidad',
            style: myStyle2
          ),
          Text(
            movie.popularity.toString(),
            style: myStyle1
          ),
          Divider(),
          Text(
            'Fecha de estreno',
            style: myStyle2
          ),
          Text(
            movie.getSimpleDate(),
            style: myStyle1
          )
        ],
      ),
    );
  }
}

class MovieProfilePicture extends StatelessWidget {

  final String imgUrl;
  final String uniqueId;

  MovieProfilePicture({
    @required this.imgUrl,
    @required this.uniqueId
  });

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 9/14,
      child: Hero(
        tag: uniqueId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/dots-loading.gif'),
            image: NetworkImage(imgUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}