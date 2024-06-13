import 'package:app_post/article_post/model/post_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'post_list_state.dart';

class PostListCubit extends Cubit<PostListState> {
  PostListCubit() : super(const PostListState.initial());

  fetchUser() async {
    try {
      emit(const PostListState.loading());
      Dio dio = Dio();

      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<Post> posts = res.data.map<Post>((d) {
          return Post.fromJson(d);
        }).toList();

        emit(PostListState.success(posts));
      } else {
        emit(PostListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(PostListState.error("Error loading data: ${e.toString()}"));
    }
  }

  void removePost(int postId) {
    if (state is PostListSuccess) {
      final updatedPosts = (state as PostListSuccess)
          .posts
          .where((post) => post.id != postId)
          .toList();
      emit(PostListSuccess(updatedPosts));
    } else {
      print("Cannot remove post, state status is not success.");
    }
  }
}
