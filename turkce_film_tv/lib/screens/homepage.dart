import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';
import 'package:turkce_film_tv/screens/profilepage.dart';
import 'package:turkce_film_tv/screens/videoplayer.dart';
import 'package:turkce_film_tv/screens/watchlist.dart';

import '../services/user_service.dart';
import 'categories.dart';

//flutter build apk -t lib/main.dart
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
  final userService = UserService();
  late final DocumentReference currentUserRef;

  bool _isOnline = true;

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

  FocusNode? _homePageNode;
  FocusNode? _watchlistNode;
  FocusNode? _categoriesNode;
  FocusNode? _playNode;
  FocusNode? _addMyWishlistNode;
  FocusNode? _listNode;
  FocusNode? _userAvatarNode;
  final _scrollController = ScrollController();

  _setFirstFocus(BuildContext context) {
    if (_homePageNode == null) {
      _homePageNode = FocusNode();
      _watchlistNode = FocusNode();
      _categoriesNode = FocusNode();
      _playNode = FocusNode();
      _addMyWishlistNode = FocusNode();
      _listNode = FocusNode();
      _userAvatarNode = FocusNode();
      FocusScope.of(context).requestFocus(_homePageNode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _homePageNode?.dispose();
    _watchlistNode?.dispose();
    _categoriesNode?.dispose();
    _playNode?.dispose();
    _addMyWishlistNode?.dispose();
    _userAvatarNode?.dispose();
    _listNode?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    currentUserRef = userService.firestore
        .collection('users')
        .doc(userService.getCurrentUserId()!);
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
      backgroundColor: Colors.black,
      body: !_isOnline
          ? Center(
              child: Container(
                  color: Colors.black, child: const Text('İnternet bağlantınız yok')),
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
                final leftPositions = [100.0, 335.0, 570.0];

// Calculate the left position dynamically based on the selectedMovieIndex and listLength
                final lastIndex = listLength - 3;
                final selectedLastIndex = selectedMovieIndex - lastIndex;
                final left = selectedMovieIndex < lastIndex
                    ? 10.0 // Use default position if selectedMovieIndex is not in the last indexes
                    : leftPositions[selectedLastIndex];

                List<String> categoryNames = selectedMovie.categories
                    .map((category) => category.split(',')[0])
                    .toList();
                String categoriesString = categoryNames.join(', ');
                print(categoriesString);

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
                                    Actions(
                                      actions: <Type, Action<Intent>>{
                                        RightButtonIntent:
                                            CallbackAction<RightButtonIntent>(
                                          onInvoke: (intent) async {
                                            await _changeFocus(
                                                context, _watchlistNode!);
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
                                            await _changeFocus(
                                                context, _playNode!);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: _homePageNode,
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
                                                await _changeFocus(
                                                    context, _homePageNode!);
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
                                                border: !(_homePageNode
                                                            ?.hasFocus ??
                                                        false)
                                                    ? null
                                                    : Border(
                                                        bottom: BorderSide(
                                                          color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.0020,
                                                        ),
                                                      ),
                                              ),
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
                                            await _changeFocus(
                                                context, _homePageNode!);
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
                                            await _changeFocus(
                                                context, _categoriesNode!);
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
                                            await _changeFocus(
                                                context, _playNode!);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: _watchlistNode,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.002,
                                          ),
                                          decoration: BoxDecoration(
                                            border: !(_watchlistNode
                                                        ?.hasFocus ??
                                                    false)
                                                ? null
                                                : Border(
                                                    bottom: BorderSide(
                                                      color: Colors.white,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.0020,
                                                    ),
                                                  ),
                                          ),
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
                                                await _changeFocus(
                                                    context, _watchlistNode!);
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
                                            await _changeFocus(
                                                context, _watchlistNode!);
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
                                            await _changeFocus(
                                                context, _userAvatarNode!);
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
                                            await _changeFocus(
                                                context, _playNode!);
                                            return null;
                                          },
                                        ),
                                      },
                                      child: Focus(
                                        focusNode: _categoriesNode,
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
                                                await _changeFocus(
                                                    context, _categoriesNode!);
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
                                                border: !(_categoriesNode
                                                            ?.hasFocus ??
                                                        false)
                                                    ? null
                                                    : Border(
                                                        bottom: BorderSide(
                                                          color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.0020,
                                                        ),
                                                      ),
                                              ),
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
                                StreamBuilder<DocumentSnapshot>(
                                  stream: currentUserRef.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (!snapshot.hasData) {
                                      return const Text('No user data found');
                                    } else {
                                      final avatar = snapshot.data!['avatar'];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.050,
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_currentPageIndex == 3) {
                                            } else {
                                              int index = 3;
                                              _pageController.jumpToPage(index);
                                              setState(() {
                                                _currentPageIndex = index;
                                              });
                                              await _changeFocus(
                                                  context, _userAvatarNode!);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: !(_userAvatarNode
                                                            ?.hasFocus ??
                                                        false)
                                                    ? Colors.transparent
                                                    : Colors.white,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0035,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.075,
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/images/avatars/$avatar.jpg',
                                                fit: BoxFit.cover,
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
                          Expanded(
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
                                            MediaQuery.of(context).size.width *
                                                0.05, // 5% of the screen width as left padding
                                            0, // 2% of the screen height as top padding
                                            MediaQuery.of(context).size.width *
                                                0.05, // 5% of the screen width as right padding
                                            0,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              child: Text(
                                                selectedMovie.title
                                                    .toUpperCase(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Bebas',
                                                    fontSize: selectedMovie
                                                                .title.length >
                                                            30
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06
                                                        : MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                  child: Image.asset(
                                                      'assets/images/imdblogo.png')),
                                              SizedBox(
                                                width: MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                              ),
                                              Text(selectedMovie.releaseYear),
                                              Text(
                                                '•',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                              ),
                                              Text(categoriesString),
                                              Text(
                                                '•',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                              ),
                                              Text('${selectedMovie.duration} dk'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.030),
                                    // Buttons
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.05, // 5% of the screen width as left padding
                                        MediaQuery.of(context).size.height *
                                            0.02, // 2% of the screen height as top padding
                                        MediaQuery.of(context).size.width *
                                            0.05, // 5% of the screen width as right padding
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Actions(
                                              actions: <Type, Action<Intent>>{
                                                RightButtonIntent:
                                                    CallbackAction<
                                                        RightButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(context,
                                                        _addMyWishlistNode!);
                                                    return null;
                                                  },
                                                ),
                                                UpButtonIntent: CallbackAction<
                                                    UpButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(context,
                                                        _homePageNode!);
                                                    return null;
                                                  },
                                                ),
                                                EnterButtonIntent:
                                                    CallbackAction<
                                                        EnterButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoPlayerScreen(
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
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(
                                                        context, _listNode!);
                                                    return null;
                                                  },
                                                ),
                                              },
                                              child: Focus(
                                                focusNode: _playNode,
                                                child: Container(
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            !(_playNode?.hasFocus ??
                                                                    false)
                                                                ? Colors.white
                                                                : Colors.black,
                                                        backgroundColor:
                                                            !(_playNode?.hasFocus ??
                                                                    false)
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  5), // set the desired border radius here
                                                          side: BorderSide(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.0020,
                                                          ), // set the desired border color and width here
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                VideoPlayerScreen(
                                                                    videoUrl:
                                                                        selectedMovie
                                                                            .url,
                                                                    subtitle:
                                                                        selectedMovie
                                                                            .subtitle),
                                                          ),
                                                        );
                                                      },
                                                      child: const FittedBox(
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
                                              actions: <Type, Action<Intent>>{
                                                LeftButtonIntent:
                                                    CallbackAction<
                                                        LeftButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(
                                                        context, _playNode!);
                                                    return null;
                                                  },
                                                ),
                                                UpButtonIntent: CallbackAction<
                                                    UpButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(context,
                                                        _homePageNode!);
                                                    return null;
                                                  },
                                                ),
                                                DownButtonIntent:
                                                    CallbackAction<
                                                        DownButtonIntent>(
                                                  onInvoke: (intent) async {
                                                    await _changeFocus(
                                                        context, _listNode!);
                                                    return null;
                                                  },
                                                ),
                                              },
                                              child: Focus(
                                                focusNode: _addMyWishlistNode,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02, // 5% of the screen width as left padding
                                                  ),
                                                  child: FutureBuilder(
                                                    future:
                                                        currentUserRef.get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final watchlist =
                                                            snapshot
                                                                .data!.reference
                                                                .collection(
                                                                    'watchlist');
                                                        return FutureBuilder<
                                                            DocumentSnapshot>(
                                                          future: watchlist
                                                              .doc(selectedMovieIndex
                                                                  .toString())
                                                              .get(),
                                                          builder: (context,
                                                              snapshot) {
                                                            final isOnWatchlist =
                                                                snapshot.hasData &&
                                                                    snapshot
                                                                        .data!
                                                                        .exists;
                                                            return Container(
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
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor: !(_addMyWishlistNode?.hasFocus ??
                                                                            false)
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    backgroundColor: !(_addMyWishlistNode?.hasFocus ??
                                                                            false)
                                                                        ? Colors
                                                                            .transparent
                                                                        : Colors
                                                                            .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5), // set the desired border radius here
                                                                      side:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.0020,
                                                                      ), // set the desired border color and width here
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    if (isOnWatchlist) {
                                                                      await watchlist
                                                                          .doc(selectedMovieIndex
                                                                              .toString())
                                                                          .delete();
                                                                    } else {
                                                                      await watchlist
                                                                          .doc(selectedMovieIndex
                                                                              .toString())
                                                                          .set({
                                                                        'movieId':
                                                                            selectedMovieIndex,
                                                                        'isWatched':
                                                                            false,
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),

                                    Actions(
                                      actions: <Type, Action<Intent>>{
                                        UpButtonIntent:
                                            CallbackAction<UpButtonIntent>(
                                          onInvoke: (intent) async {
                                            await _changeFocus(
                                                context, _playNode!);
                                            return null;
                                          },
                                        ),
                                        LeftButtonIntent:
                                            CallbackAction<LeftButtonIntent>(
                                          onInvoke: (intent) async {
                                            final screenWidth =
                                                MediaQuery.of(context)
                                                    .size
                                                    .width;
                                            final itemWidth =
                                                screenWidth * 0.25;

                                            if (selectedMovieIndex > 0) {
                                              movieProvider.moveLeft();

                                              double prevMovieOffset =
                                                  itemWidth *
                                                          (selectedMovieIndex +
                                                              1) -
                                                      _scrollController
                                                          .position.pixels;

                                              _scrollController.animateTo(
                                                _scrollController
                                                        .position.pixels +
                                                    prevMovieOffset,
                                                duration:
                                                    const Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                            return null;
                                          },
                                        ),
                                        RightButtonIntent:
                                            CallbackAction<RightButtonIntent>(
                                          onInvoke: (intent) async {
                                            final screenWidth =
                                                MediaQuery.of(context)
                                                    .size
                                                    .width;
                                            final itemWidth =
                                                screenWidth * 0.25;

                                            if (selectedMovieIndex <
                                                movieProvider.movies.length -
                                                    1) {
                                              movieProvider.moveRight();

                                              double nextMovieOffset =
                                                  itemWidth *
                                                          (selectedMovieIndex -
                                                              1) -
                                                      _scrollController
                                                          .position.pixels;

                                              _scrollController.animateTo(
                                                _scrollController
                                                        .position.pixels +
                                                    nextMovieOffset,
                                                duration:
                                                    const Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                            return null;
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
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                          ),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.32,
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  controller: _scrollController,
                                                  shrinkWrap: false,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: movieProvider
                                                      .movies.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final movie = movieProvider
                                                        .movies
                                                        .toList()[index];
                                                    final isSelected = index ==
                                                        movieProvider
                                                            .selectedMovieIndex;

                                                    final scale =
                                                        isSelected ? 1.15 : 1.0;
                                                    final hasListFocus =
                                                        _listNode!.hasFocus;

                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        right: isSelected
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025
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
                                                                0.050
                                                            : 0,
                                                      ),
                                                      child: Transform.scale(
                                                        scale: scale,
                                                        child: GestureDetector(
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
                                                          child: AspectRatio(
                                                            key: ValueKey(
                                                                movieProvider
                                                                    .selectedMovieIndex),
                                                            aspectRatio: 5 / 3,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.0045,
                                                              ),
                                                              child:
                                                                  Image.network(
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
                                                visible: _listNode!.hasFocus,
                                                child: AnimatedPositioned(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  top: 0,
                                                  bottom: 0,
                                                  left: left,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
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
