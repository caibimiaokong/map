import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wheatmap/feature/article_feature/package.dart';
import 'package:wheatmap/feature/article_feature/widget/news_button.dart';

class ArticleUI extends StatefulWidget {
  const ArticleUI({super.key});

  @override
  State<ArticleUI> createState() => _ArticleUIState();
}

class _ArticleUIState extends State<ArticleUI>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;
  final _tabs = ['ClimateChange', 'AgriCulture', 'EnvironmentProtection'];
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => PostBloc()..add(PostFetchedAll()),
      child: Scaffold(
        body: NestedScrollView(
          //sliverAppbar
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: const Color(0xFFB4EBFD),
                expandedHeight: 270,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                  'lib/feature/article_feature/assets/polar_bear_transformed.png',
                  fit: BoxFit.cover,
                )),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: const Color(0xFFB4EBFD),
                    child: TabBar(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: _tabController,
                      isScrollable: true,
                      tabs: _tabs
                          .map((String title) => NewsButton(title: title))
                          .toList(),
                    ),
                  ),
                ),
                pinned: true,
              ),
            ];
          },

          //PostList
          body: TabBarView(
            controller: _tabController,
            children: const [
              NewsList(index: 0),
              NewsList(index: 1),
              NewsList(index: 2),
            ],
          ),
        ),
      ),
    );
  }
}
