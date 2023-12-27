part of 'article_bloc_bloc.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class UpdatePost extends PostEvent {
  UpdatePost(this.index);
  final int index;
}

final class PostFetchedAll extends PostEvent {
  PostFetchedAll();
}
