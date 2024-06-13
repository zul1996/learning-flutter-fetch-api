import 'package:app_post/article_post/article_post.dart';
import 'package:app_post/article_post/view/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_list_view.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostListCubit(),
      child: const PostListView(),
    );
  }
}
