import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';
import 'package:turkce_film_tv/screens/profilepage.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';
import 'package:turkce_film_tv/screens/watchlist.dart';
import 'package:turkce_film_tv/services/focusnodeservice.dart';

import '../models/movie_models.dart';
import '../services/searchservice.dart';
import '../services/user_service.dart';
import '../widgets/search_widget.dart';
import '../widgets/shortcutswidget.dart';
import 'categories.dart';

//flutter build apk -t lib/main.dart
class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

enum DPadDirection {
  up,
  down,
  left,
  right,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DPadDirection currentDirection;

  void handleDirectionChange(DPadDirection direction) {
    setState(() {
      currentDirection = direction;
      // Perform actions based on the currentDirection
      switch (currentDirection) {
        case DPadDirection.up:
          print('Up button pressed');
          break;
        case DPadDirection.down:
          print('Down button pressed');
          break;
        case DPadDirection.left:
          print('Left button pressed');
          break;
        case DPadDirection.right:
          print('Right button pressed');
          break;
      }
    });
  }

  final userService = UserService();
  late final DocumentReference currentUserRef;
  String _searchQuery = '';
  bool _isOnline = true;
  bool _searchisVisible = false;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  Future<void> _checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isOnline = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isOnline = false;
      });
    }
  }

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    currentUserRef = userService.firestore
        .collection('users')
        .doc(userService.getCurrentUserId()!);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusService.changeFocus(context, FocusService.homepageMenuAnasayfaNode);
    });
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
    print(node);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.20;

    return Scaffold(
      backgroundColor: Colors.black,
      body: !_isOnline
          ? Center(
              child: Container(
                  color: Colors.black,
                  child: const Text('İnternet bağlantınız yok')),
            )
          : Consumer<MovieProvider>(
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
                  precacheImage(
                      NetworkImage(nextMovie.backgroundImageUrl), context);
                }

                bool isEndOfList = selectedMovieIndex >= listLength - 3;
                final leftPositions = [
                  MediaQuery.of(context).size.width * 0.24,
                  MediaQuery.of(context).size.width * 0.44,
                  MediaQuery.of(context).size.width * 0.64,
                ];

                final lastIndex = listLength - 3;
                final selectedLastIndex = selectedMovieIndex - lastIndex;
                final left = selectedMovieIndex < lastIndex
                    ? 10.0 // Use default position if selectedMovieIndex is not in the last indexes
                    : leftPositions[selectedLastIndex];

                List<String> categoryNames = selectedMovie.categories
                    .map((category) => category.split(',')[0])
                    .toList();
                String categoriesString = categoryNames.join(', ');

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
                              return const LinearGradient(
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
                                  image: NetworkImage(
                                      selectedMovie.backgroundImageUrl),
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
                        LogicalKeySet(LogicalKeyboardKey.arrowUp):
                            UpButtonIntent(),
                        LogicalKeySet(LogicalKeyboardKey.arrowDown):
                            DownButtonIntent(),
                        LogicalKeySet(LogicalKeyboardKey.select):
                            EnterButtonIntent(),
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Top menu
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              0,
                              0,
                              0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.040,
                                      child:
                                          Image.asset('assets/images/logo.png'),
                                    ),
                                    Actions(
                                      actions: <Type, Action<Intent>>{
                                        RightButtonIntent:
                                            CallbackAction<RightButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(
                                                context,
                                                FocusService
                                                    .homepageMenuWatchlistNode);
                                            int index = 1;
                                            _pageController.jumpToPage(index);
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                            return null;
                                          },
                                        ),
                                        DownButtonIntent:
                                            CallbackAction<DownButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(context,
                                                FocusService.homepagePlayNode);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: FocusService
                                            .homepageMenuAnasayfaNode,
                                        child: Container(
                                          child: TextButton(
                                            onPressed: () async {
                                              if (_currentPageIndex == 0) {
                                              } else {
                                                int index = 0;
                                                _pageController
                                                    .jumpToPage(index);
                                                setState(() {
                                                  _currentPageIndex = index;
                                                });
                                                FocusService.changeFocus(
                                                    context,
                                                    FocusService
                                                        .homepageMenuAnasayfaNode);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005,
                                              ),
                                              decoration: BoxDecoration(
                                                  border: (FocusService
                                                          .homepageMenuAnasayfaNode
                                                          .hasFocus)
                                                      ? Border(
                                                          bottom: BorderSide(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.0020,
                                                          ),
                                                        )
                                                      : null),
                                              child: const Text(
                                                'Anasayfa',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                            FocusService.changeFocus(
                                                context,
                                                FocusService
                                                    .homepageMenuAnasayfaNode);
                                            int index = 0;
                                            _pageController.jumpToPage(index);
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                            return null;
                                          },
                                        ),
                                        RightButtonIntent:
                                            CallbackAction<RightButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(
                                                context,
                                                FocusService
                                                    .homepageMenuCategoriesNode);
                                            int index = 3;
                                            _pageController.jumpToPage(index);
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                            return null;
                                          },
                                        ),
                                        DownButtonIntent:
                                            CallbackAction<DownButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(context,
                                                FocusService.homepagePlayNode);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: FocusService
                                            .homepageMenuWatchlistNode,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: (FocusService
                                                      .homepageMenuWatchlistNode
                                                      .hasFocus)
                                                  ? Border(
                                                      bottom: BorderSide(
                                                        color: Colors.white,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.0020,
                                                      ),
                                                    )
                                                  : null),
                                          child: TextButton(
                                            onPressed: () async {
                                              if (_currentPageIndex == 1) {
                                              } else {
                                                int index = 1;
                                                _pageController
                                                    .jumpToPage(index);
                                                setState(() {
                                                  _currentPageIndex = index;
                                                });
                                                FocusService.changeFocus(
                                                    context,
                                                    FocusService
                                                        .homepageMenuWatchlistNode);
                                              }
                                            },
                                            child: const Text(
                                              'Listem',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                            FocusService.changeFocus(
                                                context,
                                                FocusService
                                                    .homepageMenuWatchlistNode);
                                            int index = 1;
                                            _pageController.jumpToPage(index);
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                            return null;
                                          },
                                        ),
                                        RightButtonIntent:
                                            CallbackAction<RightButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(
                                                context,
                                                FocusService
                                                    .homepageMenuAvatarNode);
                                            int index = 3;
                                            _pageController.jumpToPage(index);
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                            return null;
                                          },
                                        ),
                                        DownButtonIntent:
                                            CallbackAction<DownButtonIntent>(
                                          onInvoke: (intent) async {
                                            FocusService.changeFocus(context,
                                                FocusService.homepagePlayNode);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: FocusService
                                            .homepageMenuCategoriesNode,
                                        child: Container(
                                          child: TextButton(
                                            onPressed: () async {
                                              if (_currentPageIndex == 2) {
                                              } else {
                                                int index = 2;
                                                _pageController
                                                    .jumpToPage(index);
                                                setState(() {
                                                  _currentPageIndex = index;
                                                });
                                                FocusService.changeFocus(
                                                    context,
                                                    FocusService
                                                        .homepageMenuCategoriesNode);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005,
                                              ),
                                              decoration: BoxDecoration(
                                                  border: (FocusService
                                                          .homepageMenuCategoriesNode
                                                          .hasFocus)
                                                      ? Border(
                                                          bottom: BorderSide(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.0020,
                                                          ),
                                                        )
                                                      : null),
                                              child: const Text(
                                                'Kategoriler',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.580,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SearchVisibilityWidget(
                                          key: const ValueKey(
                                              'my_search_widget'),
                                          isVisible: _searchisVisible,
                                          onChanged: (value) {
                                            setState(() {
                                              _searchQuery = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Actions(
                                        actions: <Type, Action<Intent>>{
                                          LeftButtonIntent:
                                              CallbackAction<LeftButtonIntent>(
                                            onInvoke: (intent) async {
                                              FocusService.changeFocus(
                                                  context,
                                                  FocusService
                                                      .homepageMenuCategoriesNode);
                                              int index = 2;
                                              _pageController.jumpToPage(index);
                                              setState(() {
                                                _currentPageIndex = index;
                                              });
                                              return null;
                                            },
                                          ),
                                          RightButtonIntent:
                                              CallbackAction<RightButtonIntent>(
                                            onInvoke: (intent) async {
                                              FocusService.changeFocus(
                                                  context,
                                                  FocusService
                                                      .homepageMenuAvatarNode);
                                              int index = 3;
                                              _pageController.jumpToPage(index);
                                              setState(() {
                                                _currentPageIndex = index;
                                              });
                                              return null;
                                            },
                                          ),
                                          DownButtonIntent:
                                              CallbackAction<DownButtonIntent>(
                                            onInvoke: (intent) async {
                                              FocusService.changeFocus(
                                                  context,
                                                  FocusService
                                                      .homepagePlayNode);
                                              return null;
                                            },
                                          ),
                                        },
                                        child: Focus(
                                          focusNode: FocusService
                                              .homepageMenuSearchNode,
                                          child: GestureDetector(
                                            onTap: () async {
                                              FocusService.changeFocus(
                                                  context,
                                                  FocusService
                                                      .homepageMenuSearchNode);
                                              setState(() {
                                                _searchisVisible =
                                                    !_searchisVisible;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: (FocusService
                                                        .homepageMenuSearchNode
                                                        .hasFocus)
                                                    ? Border.all(
                                                        color: Colors.white,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.0020,
                                                      )
                                                    : null,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.095,
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.110, // change to desired width
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.110,
                                                  child: Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.050,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: currentUserRef.snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (!snapshot.hasData) {
                                            return const Text(
                                                'No user data found');
                                          } else {
                                            final avatar =
                                                snapshot.data!['avatar'];
                                            return Actions(
                                              actions: <Type, Action<Intent>>{
                                                LeftButtonIntent:
                                                    CallbackAction<
                                                        LeftButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    FocusService.changeFocus(
                                                        context,
                                                        FocusService
                                                            .homepageMenuSearchNode);
                                                  },
                                                ),
                                              },
                                              child: Focus(
                                                focusNode: FocusService
                                                    .homepageMenuAvatarNode,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.050,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (_currentPageIndex ==
                                                          3) {
                                                      } else {
                                                        int index = 3;
                                                        _pageController
                                                            .jumpToPage(index);
                                                        setState(() {
                                                          _currentPageIndex =
                                                              index;
                                                        });
                                                        FocusService.changeFocus(
                                                            context,
                                                            FocusService
                                                                .homepageMenuAvatarNode);
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: (FocusService
                                                                  .homepageMenuAvatarNode
                                                                  .hasFocus)
                                                              ? Colors.white
                                                              : Colors
                                                                  .transparent,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.0035,
                                                        ),
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.060,
                                                      child: ClipOval(
                                                        child: Image.asset(
                                                          'assets/images/avatars/$avatar.jpg',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _searchQuery != "" || _searchQuery.isNotEmpty
                              ? FutureBuilder<List<Movie>>(
                                  future:
                                      SearchService.searchMovies(_searchQuery),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      final movies = snapshot.data!;

                                      if (movies.isEmpty) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09, // 5% of the screen width as left padding
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15, // 2% of the screen height as top padding
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09, // 5% of the screen width as right padding
                                              0,
                                            ),
                                            child: Text(
                                              'Aradığınız film bulunamadı',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.030),
                                            ),
                                          ),
                                        );
                                      }

                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              0.09, // 5% of the screen width as left padding
                                          0, // 2% of the screen height as top padding
                                          MediaQuery.of(context).size.width *
                                              0.09, // 5% of the screen width as right padding
                                          0,
                                        ),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          child: GridView.builder(
                                            itemCount: movies.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 5 / 3,
                                            ),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerScreen(
                                                              videoUrl:
                                                                  movies[index]
                                                                      .url,
                                                              subtitle: movies[
                                                                      index]
                                                                  .subtitle),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  child: AspectRatio(
                                                    aspectRatio: 5 / 3,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.0045,
                                                      ),
                                                      child: Image.network(
                                                        movies[index]
                                                            .posterImageUrl,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Expanded(
                                  child: PageView(
                                    controller: _pageController,
                                    onPageChanged: (int index) {
                                      setState(() {
                                        _currentPageIndex = index;
                                      });
                                    },
                                    children: [
                                      Column(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of the screen width as left padding
                                                  0, // 2% of the screen height as top padding
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of the screen width as right padding
                                                  0,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.19,
                                                    child: Text(
                                                      selectedMovie.title
                                                          .toUpperCase(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: 'Bebas',
                                                          fontSize: selectedMovie
                                                                      .title.length >
                                                                  30
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.06
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    0,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    0),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: Image.asset(
                                                            'assets/images/imdblogo.png')),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                    ),
                                                    Text(
                                                      selectedMovie.imdbRating,
                                                    ),
                                                    Text(
                                                      '•',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02),
                                                    ),
                                                    Text(selectedMovie
                                                        .releaseYear),
                                                    Text(
                                                      '•',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02),
                                                    ),
                                                    Text(categoriesString),
                                                    Text(
                                                      '•',
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02),
                                                    ),
                                                    Text(
                                                        '${selectedMovie.duration} dk'),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.030),
                                          // Buttons
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05, // 5% of the screen width as left padding
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02, // 2% of the screen height as top padding
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05, // 5% of the screen width as right padding
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Actions(
                                                    actions: <Type,
                                                        Action<Intent>>{
                                                      RightButtonIntent:
                                                          CallbackAction<
                                                              RightButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepageAddToListNode);
                                                          return null;
                                                        },
                                                      ),
                                                      UpButtonIntent:
                                                          CallbackAction<
                                                              UpButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepageMenuAnasayfaNode);
                                                          return null;
                                                        },
                                                      ),
                                                      EnterButtonIntent:
                                                          CallbackAction<
                                                              EnterButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => VideoPlayerScreen(
                                                                  videoUrl:
                                                                      selectedMovie
                                                                          .url,
                                                                  subtitle:
                                                                      selectedMovie
                                                                          .subtitle),
                                                            ),
                                                          );
                                                          return null;
                                                        },
                                                      ),
                                                      DownButtonIntent:
                                                          CallbackAction<
                                                              DownButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepageListNode);
                                                          return null;
                                                        },
                                                      ),
                                                    },
                                                    child: Focus(
                                                      focusNode: FocusService
                                                          .homepagePlayNode,
                                                      child: Container(
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  (FocusService
                                                                          .homepagePlayNode
                                                                          .hasFocus)
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                              backgroundColor: (FocusService
                                                                      .homepagePlayNode
                                                                      .hasFocus)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .transparent,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5), // set the desired border radius here
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.0020,
                                                                ), // set the desired border color and width here
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => VideoPlayerScreen(
                                                                      videoUrl:
                                                                          selectedMovie
                                                                              .url,
                                                                      subtitle:
                                                                          selectedMovie
                                                                              .subtitle),
                                                                ),
                                                              );
                                                            },
                                                            child:
                                                                const FittedBox(
                                                              child: Text(
                                                                'Oynat',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Actions(
                                                    actions: <Type,
                                                        Action<Intent>>{
                                                      LeftButtonIntent:
                                                          CallbackAction<
                                                              LeftButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepagePlayNode);
                                                          return null;
                                                        },
                                                      ),
                                                      UpButtonIntent:
                                                          CallbackAction<
                                                              UpButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepageMenuAnasayfaNode);
                                                          return null;
                                                        },
                                                      ),
                                                      DownButtonIntent:
                                                          CallbackAction<
                                                              DownButtonIntent>(
                                                        onInvoke:
                                                            (intent) async {
                                                          FocusService.changeFocus(
                                                              context,
                                                              FocusService
                                                                  .homepageListNode);
                                                          return null;
                                                        },
                                                      ),
                                                    },
                                                    child: Focus(
                                                      focusNode: FocusService
                                                          .homepageAddToListNode,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02, // 5% of the screen width as left padding
                                                        ),
                                                        child: FutureBuilder(
                                                          future: currentUserRef
                                                              .get(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              final watchlist =
                                                                  snapshot.data!
                                                                      .reference
                                                                      .collection(
                                                                          'watchlist');
                                                              return FutureBuilder<
                                                                  DocumentSnapshot>(
                                                                future: watchlist
                                                                    .doc(selectedMovie
                                                                        .movieId
                                                                        .toString())
                                                                    .get(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  final isOnWatchlist = snapshot
                                                                          .hasData &&
                                                                      snapshot
                                                                          .data!
                                                                          .exists;
                                                                  return Container(
                                                                    child:
                                                                        SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.07,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.15,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          foregroundColor: (FocusService.homepageAddToListNode.hasFocus)
                                                                              ? Colors.black
                                                                              : Colors.white,
                                                                          backgroundColor: (FocusService.homepageAddToListNode.hasFocus)
                                                                              ? Colors.white
                                                                              : Colors.transparent,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5), // set the desired border radius here
                                                                            side:
                                                                                BorderSide(
                                                                              color: Colors.white,
                                                                              width: MediaQuery.of(context).size.width * 0.0020,
                                                                            ), // set the desired border color and width here
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          if (isOnWatchlist) {
                                                                            final querySnapshot =
                                                                                await watchlist.where('movieId', isEqualTo: selectedMovie.movieId).get();
                                                                            if (querySnapshot.docs.isNotEmpty) {
                                                                              final docId = querySnapshot.docs.first.id;
                                                                              await watchlist.doc(docId).delete();
                                                                            }
                                                                          } else {
                                                                            await watchlist.doc(selectedMovie.movieId.toString()).set({
                                                                              'movieId': selectedMovie.movieId,
                                                                              'isWatched': false,
                                                                              'timestamp': FieldValue.serverTimestamp(),
                                                                            });
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            FittedBox(
                                                                          child: Text(isOnWatchlist
                                                                              ? 'Listeden Sil'
                                                                              : 'Listeye ekle'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              return const CircularProgressIndicator();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05, // 5% of the screen width as left padding
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Son Eklenen Filmler',
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    handleDirectionChange(
                                                        DPadDirection.up),
                                                child: Text('Yukarı git'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  FocusService.changeFocus(
                                                      context,
                                                      FocusService
                                                          .homepagePlayNode);
                                                },
                                                child: Text('Aşağı git'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  FocusService.changeFocus(
                                                      context,
                                                      FocusService
                                                          .homepageAddToListNode);
                                                },
                                                child: Text('Sol git'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  FocusService.changeFocus(
                                                      context,
                                                      FocusService
                                                          .homepagePlayNode);
                                                },
                                                child: Text('Sağ git'),
                                              ),
                                            ],
                                          ),

                                          Actions(
                                            actions: <Type, Action<Intent>>{
                                              UpButtonIntent: CallbackAction<
                                                  UpButtonIntent>(
                                                onInvoke: (intent) async {
                                                  FocusService.changeFocus(
                                                      context,
                                                      FocusService
                                                          .homepageListNode);
                                                  return null;
                                                },
                                              ),
                                              LeftButtonIntent: CallbackAction<
                                                  LeftButtonIntent>(
                                                onInvoke: (intent) async {
                                                  if (selectedMovieIndex == 0) {
                                                  } else if (selectedMovieIndex >
                                                      0) {
                                                    movieProvider.moveLeft();

                                                    double prevMovieOffset =
                                                        itemWidth *
                                                                (selectedMovieIndex -
                                                                    1) -
                                                            _scrollController
                                                                .position
                                                                .pixels;

                                                    _scrollController.animateTo(
                                                      _scrollController
                                                              .position.pixels +
                                                          prevMovieOffset,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  }
                                                },
                                              ),
                                              RightButtonIntent: CallbackAction<
                                                  RightButtonIntent>(
                                                onInvoke: (intent) async {
                                                  if (selectedMovieIndex ==
                                                      movieProvider
                                                              .movies.length +
                                                          1) {
                                                  } else if (selectedMovieIndex <
                                                      movieProvider
                                                              .movies.length -
                                                          1) {
                                                    movieProvider.moveRight();

                                                    double nextMovieOffset =
                                                        itemWidth *
                                                                (selectedMovieIndex +
                                                                    1) -
                                                            _scrollController
                                                                .position
                                                                .pixels;

                                                    _scrollController.animateTo(
                                                      _scrollController
                                                              .position.pixels +
                                                          nextMovieOffset,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  }
                                                },
                                              ),
                                            },
                                            child: Focus(
                                              focusNode:
                                                  FocusService.homepageListNode,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of the screen width as left padding
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02, // 2% of the screen height as top padding
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of the screen width as right padding
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.32,
                                                      width: double.infinity,
                                                      child: ListView.builder(
                                                        controller:
                                                            _scrollController,
                                                        shrinkWrap: false,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: movieProvider
                                                            .movies.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final movie =
                                                              movieProvider
                                                                      .movies
                                                                      .toList()[
                                                                  index];
                                                          final isSelected =
                                                              index ==
                                                                  movieProvider
                                                                      .selectedMovieIndex;

                                                          final scale =
                                                              isSelected
                                                                  ? 1.15
                                                                  : 1.0;
                                                          final hasListFocus =
                                                              FocusService
                                                                  .homepageListNode
                                                                  .hasFocus;

                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: isSelected
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.030
                                                                  : 0,
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.016,
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.016,
                                                              left: isSelected
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.027
                                                                  : 0,
                                                            ),
                                                            child:
                                                                Transform.scale(
                                                              scale: scale,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  if (movieProvider
                                                                          .selectedMovieIndex !=
                                                                      index) {
                                                                    movieProvider
                                                                        .selectMovie(
                                                                            index);
                                                                  } else if (movieProvider
                                                                          .selectedMovieIndex ==
                                                                      0) {
                                                                  } else if (movieProvider
                                                                          .selectedMovieIndex ==
                                                                      index) {
                                                                  } else if (index <
                                                                      movieProvider
                                                                              .movies
                                                                              .length -
                                                                          1) {
                                                                    movieProvider
                                                                        .selectMovie(
                                                                            index +
                                                                                1);
                                                                  }
                                                                },
                                                                child:
                                                                    AspectRatio(
                                                                  key: ValueKey(
                                                                      movieProvider
                                                                          .selectedMovieIndex),
                                                                  aspectRatio:
                                                                      5 / 3,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.0045,
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      movie
                                                                          .posterImageUrl,
                                                                      fit: BoxFit
                                                                          .cover,
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
                                                      visible: FocusService
                                                          .homepageListNode
                                                          .hasFocus,
                                                      child: AnimatedPositioned(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve: Curves.easeInOut,
                                                        top: 0,
                                                        bottom: 0,
                                                        left: left,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
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
                                      const UserWatchlistPage(),
                                      const CategoriesScreen(),
                                      const ProfilePage(),
                                    ],
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
