part of 'post_list_page.dart';

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  int _currentPage = 1;
  int _perPage = 5; // Jumlah item per halaman

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
      ),
      body: BlocBuilder<PostListCubit, PostListState>(
        builder: (context, state) {
          if (state is PostListSuccess) {
            // Menghitung indeks awal dan akhir untuk pagination
            int startIndex = (_currentPage - 1) * _perPage;
            int endIndex = startIndex + _perPage;
            endIndex =
                endIndex > state.posts.length ? state.posts.length : endIndex;

            // List item untuk halaman saat ini
            List<Post> currentPagePosts =
                state.posts.sublist(startIndex, endIndex);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: currentPagePosts.length,
                    itemBuilder: (context, index) {
                      final post = currentPagePosts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Text(post.id.toString()),
                        ),
                        title: Text(post.title.length > 50
                            ? '${post.title.substring(0, 50)}...'
                            : post.title),
                        subtitle: Text(post.body.length > 50
                            ? '${post.body.substring(0, 50)}...'
                            : post.body),
                        onLongPress: () {
                          _showDeleteConfirmationDialog(context, post.id);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailPage(post: post),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed:
                            _currentPage > 1 ? () => _changePage(-1) : null,
                      ),
                      Text('Halaman $_currentPage'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _currentPage * _perPage < state.posts.length
                            ? () => _changePage(1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is PostListError) {
            // Error
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  ElevatedButton(
                    child: const Text("Refresh"),
                    onPressed: () => context.read<PostListCubit>().fetchUser(),
                  ),
                ],
              ),
            );
          } else if (state is PostListLoading) {
            // Loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () => context.read<PostListCubit>().fetchUser(),
              ),
            );
            // Initial / First time
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => context.read<PostListCubit>().fetchUser(),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Postingan'),
          content:
              const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<PostListCubit>().removePost(postId);
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _changePage(int increment) {
    setState(() {
      _currentPage += increment;
    });
  }
}
