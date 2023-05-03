import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/models/movie_models.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedMovieIndex = 0;

  FocusNode? _homePageNode;
  FocusNode? _watchlistNode;
  FocusNode? _categoriesNode;
  FocusNode? _playNode;
  FocusNode? _addMyWishlistNode;
  FocusNode? _listNode;
  final _scrollController = ScrollController();

  _setFirstFocus(BuildContext context) {
    if (_homePageNode == null) {
      _homePageNode = FocusNode();
      _watchlistNode = FocusNode();
      _categoriesNode = FocusNode();
      _playNode = FocusNode();
      _addMyWishlistNode = FocusNode();
      _listNode = FocusNode();
      FocusScope.of(context).requestFocus(_homePageNode);
    }
  }

  void dispose() {
    super.dispose();
    _homePageNode?.dispose();
    _watchlistNode?.dispose();
    _categoriesNode?.dispose();
    _playNode?.dispose();
    _addMyWishlistNode?.dispose();
    _listNode?.dispose();
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_homePageNode == null) {
      _setFirstFocus(context);
    }

    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          final selectedMovie =
              movieProvider.movies[movieProvider.selectedMovieIndex];
          final nextMovieIndex = movieProvider.selectedMovieIndex + 1;

          final nextMovie = nextMovieIndex < movieProvider.movies.length
              ? movieProvider.movies[nextMovieIndex]
              : null;

          final selectedMovieIndex = movieProvider.selectedMovieIndex;
          int listLength = movieProvider.movies.length;
          if (nextMovie != null) {
            precacheImage(NetworkImage(nextMovie.backgroundImageUrl), context);
          }

          bool isEndOfList = selectedMovieIndex >= listLength - 3;
          final leftPositions = [100.0, 335.0, 570.0];

// Calculate the left position dynamically based on the selectedMovieIndex and listLength
          final lastIndex = listLength - 3;
          final selectedLastIndex = selectedMovieIndex - lastIndex;
          final left = selectedMovieIndex < lastIndex
              ? 10.0 // Use default position if selectedMovieIndex is not in the last indexes
              : leftPositions[selectedLastIndex];

          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.darken,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage(selectedMovie.backgroundImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Shortcuts(
                shortcuts: <LogicalKeySet, Intent>{
                  LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                      LeftButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowRight):
                      RightButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowUp): UpButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                      DownButtonIntent(),
                  LogicalKeySet(LogicalKeyboardKey.select): EnterButtonIntent(),
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Top menu
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.05,
                        MediaQuery.of(context).size.height * 0.01,
                        0,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Actions(
                            actions: <Type, Action<Intent>>{
                              RightButtonIntent:
                                  CallbackAction<RightButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _watchlistNode!);
                                },
                              ),
                              DownButtonIntent:
                                  CallbackAction<DownButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _playNode!);
                                },
                              ),
                            },
                            child: Focus(
                              focusNode: _homePageNode,
                              child: Container(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    child: Text(
                                      'Anasayfa',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      border: !(_homePageNode?.hasFocus ??
                                              false)
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                color: Colors.white,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0020,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Actions(
                            actions: <Type, Action<Intent>>{
                              LeftButtonIntent:
                                  CallbackAction<LeftButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _homePageNode!);
                                },
                              ),
                              RightButtonIntent:
                                  CallbackAction<RightButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _categoriesNode!);
                                },
                              ),
                              DownButtonIntent:
                                  CallbackAction<DownButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _playNode!);
                                },
                              ),
                            },
                            child: Focus(
                              focusNode: _watchlistNode,
                              child: Container(
                                child: Text(
                                  'Listem',
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  border: !(_watchlistNode?.hasFocus ?? false)
                                      ? null
                                      : Border(
                                          bottom: BorderSide(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0020,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Actions(
                            actions: <Type, Action<Intent>>{
                              LeftButtonIntent:
                                  CallbackAction<LeftButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _watchlistNode!);
                                },
                              ),
                              DownButtonIntent:
                                  CallbackAction<DownButtonIntent>(
                                onInvoke: (intent) async {
                                  await _changeFocus(context, _playNode!);
                                },
                              ),
                            },
                            child: Focus(
                              focusNode: _categoriesNode,
                              child: Container(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    child: Text(
                                      'Kategoriler',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      border: !(_categoriesNode?.hasFocus ??
                                              false)
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                color: Colors.white,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0020,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width *
                                0.05, // 5% of the screen width as left padding
                            MediaQuery.of(context).size.height *
                                0.02, // 2% of the screen height as top padding
                            MediaQuery.of(context).size.width *
                                0.05, // 5% of the screen width as right padding
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.17,
                              child: Expanded(
                                child: Text(
                                  selectedMovie.title.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Bebas',
                                      fontSize: selectedMovie.title.length > 30
                                          ? MediaQuery.of(context).size.width *
                                              0.06
                                          : MediaQuery.of(context).size.width *
                                              0.08,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              0,
                              MediaQuery.of(context).size.width * 0.05,
                              0),
                          child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                  child: Image.asset(
                                      'assets/images/imdblogo.png')),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Text(
                                selectedMovie.imdbRating,
                              ),
                              Text(
                                '•',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                              ),
                              Text(selectedMovie.releaseYear),
                              Text(
                                '•',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                              ),
                              Text('Action, Comedy'),
                              Text(
                                '•',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                              ),
                              Text(selectedMovie.duration),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030),
                    // Buttons
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width *
                            0.05, // 5% of the screen width as left padding
                        MediaQuery.of(context).size.height *
                            0.02, // 2% of the screen height as top padding
                        MediaQuery.of(context).size.width *
                            0.05, // 5% of the screen width as right padding
                        MediaQuery.of(context).size.height * 0.04,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Actions(
                              actions: <Type, Action<Intent>>{
                                RightButtonIntent:
                                    CallbackAction<RightButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(
                                        context, _addMyWishlistNode!);
                                  },
                                ),
                                UpButtonIntent: CallbackAction<UpButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(context, _homePageNode!);
                                  },
                                ),
                                EnterButtonIntent:
                                    CallbackAction<EnterButtonIntent>(
                                  onInvoke: (intent) async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                            videoUrl: selectedMovie.url),
                                      ),
                                    );
                                  },
                                ),
                                DownButtonIntent:
                                    CallbackAction<DownButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(context, _listNode!);
                                  },
                                ),
                              },
                              child: Focus(
                                focusNode: _playNode,
                                child: Container(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            !(_playNode?.hasFocus ?? false)
                                                ? Colors.white
                                                : Colors.black,
                                        backgroundColor:
                                            !(_playNode?.hasFocus ?? false)
                                                ? Colors.transparent
                                                : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // set the desired border radius here
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0020,
                                          ), // set the desired border color and width here
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                                    videoUrl:
                                                        selectedMovie.url),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Oynat',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Actions(
                              actions: <Type, Action<Intent>>{
                                LeftButtonIntent:
                                    CallbackAction<LeftButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(context, _playNode!);
                                  },
                                ),
                                UpButtonIntent: CallbackAction<UpButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(context, _homePageNode!);
                                  },
                                ),
                                DownButtonIntent:
                                    CallbackAction<DownButtonIntent>(
                                  onInvoke: (intent) async {
                                    await _changeFocus(context, _listNode!);
                                  },
                                ),
                              },
                              child: Focus(
                                focusNode: _addMyWishlistNode,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02, // 5% of the screen width as left padding
                                  ),
                                  child: Container(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              !(_addMyWishlistNode?.hasFocus ??
                                                      false)
                                                  ? Colors.white
                                                  : Colors.black,
                                          backgroundColor:
                                              !(_addMyWishlistNode?.hasFocus ??
                                                      false)
                                                  ? Colors.transparent
                                                  : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5), // set the desired border radius here
                                            side: BorderSide(
                                              color: Colors.white,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0020,
                                            ), // set the desired border color and width here
                                          ),
                                        ),
                                        onPressed: () {
                                          // add your button onPressed code here
                                        },
                                        child: Text(
                                          'Listeye ekle',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width *
                            0.05, // 5% of the screen width as left padding
                        0, // 2% of the screen height as top padding
                        MediaQuery.of(context).size.width *
                            0.05, // 5% of the screen width as right padding
                        0,
                      ),
                      child: Text('Son Eklenen Filmler',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              fontWeight: FontWeight.w400)),
                    ),

                    Actions(
                      actions: <Type, Action<Intent>>{
                        UpButtonIntent: CallbackAction<UpButtonIntent>(
                          onInvoke: (intent) async {
                            await _changeFocus(context, _playNode!);
                          },
                        ),
                        LeftButtonIntent: CallbackAction<LeftButtonIntent>(
                          onInvoke: (intent) async {
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            final itemWidth = screenWidth * 0.25;

                            if (selectedMovieIndex > 0) {
                              movieProvider.moveLeft();

                              double prevMovieOffset =
                                  itemWidth * (selectedMovieIndex - 1) -
                                      _scrollController.position.pixels;

                              _scrollController.animateTo(
                                _scrollController.position.pixels +
                                    prevMovieOffset,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        RightButtonIntent: CallbackAction<RightButtonIntent>(
                          onInvoke: (intent) async {
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            final itemWidth = screenWidth * 0.25;

                            if (selectedMovieIndex <
                                movieProvider.movies.length - 1) {
                              movieProvider.moveRight();

                              double nextMovieOffset =
                                  itemWidth * (selectedMovieIndex + 1) -
                                      _scrollController.position.pixels;

                              _scrollController.animateTo(
                                _scrollController.position.pixels +
                                    nextMovieOffset,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      },
                      child: Focus(
                        focusNode: _listNode,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width *
                                0.05, // 5% of the screen width as left padding
                            MediaQuery.of(context).size.height *
                                0.02, // 2% of the screen height as top padding
                            MediaQuery.of(context).size.width *
                                0.05, // 5% of the screen width as right padding
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.32,
                                width: double.infinity,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movieProvider.movies.length,
                                  itemBuilder: (context, index) {
                                    final movie = movieProvider.movies[index];
                                    final isSelected =
                                        movieProvider.selectedMovieIndex ==
                                            index;
                                    final scale = isSelected ? 1.15 : 1.0;
                                    final hasListFocus = _listNode!.hasFocus;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: isSelected
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025
                                            : 0,
                                        top: MediaQuery.of(context).size.width *
                                            0.016,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.016,
                                        left: isSelected
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.050
                                            : 0,
                                      ),
                                      child: Transform.scale(
                                        scale: scale,
                                        child: GestureDetector(
                                          onTap: () {
                                            movieProvider.selectMovie(index);
                                          },
                                          child: AspectRatio(
                                            key: ValueKey(movieProvider
                                                .selectedMovieIndex),
                                            aspectRatio: 5 / 3,
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0045,
                                              ),
                                              child: Image.network(
                                                movie.posterImageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _listNode!.hasFocus,
                                child: AnimatedPositioned(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  top: 0,
                                  bottom: 0,
                                  left: left,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.0035,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/*
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode? _homePageNode;
  FocusNode? _watchlistNode;
  FocusNode? _categoriesNode;
  FocusNode? _playNode;
  FocusNode? _addMyWishlistNode;
  FocusNode? _listNode;

  _setFirstFocus(BuildContext context) {
    if (_homePageNode == null) {
      _watchlistNode = FocusNode();
      _categoriesNode = FocusNode();
      _playNode = FocusNode();
      _addMyWishlistNode = FocusNode();
      _listNode = FocusNode();
      FocusScope.of(context).requestFocus(_homePageNode);
    }
    _changeFocus(BuildContext context, FocusNode node) {
      FocusScope.of(context).requestFocus(node);
    }

    void dispose() {
      super.dispose();
      _homePageNode?.dispose();
      _watchlistNode?.dispose();
      _categoriesNode?.dispose();
      _playNode?.dispose();
      _addMyWishlistNode?.dispose();
      _listNode?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_homePageNode == null) {
      _setFirstFocus(context);
    }
    int selectedMovieIndex = 0;

    final movieProvider = Provider.of<MovieProvider>(context);
    final selectedMovie = movieProvider.movies[selectedMovieIndex];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(selectedMovie.backgroundImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Movies',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: movieProvider.movies.length,
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final movie = movieProvider.movies[index];
                    return Text('SA');
                    /*return GestureDetector(
                        onTap: () {
                          movieProvider.selectMovie(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3.5,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 6 / 3,
                            child: Image.network(
                              movie.posterImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );*/
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/

