part of 'article_bloc_bloc.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  PostState({
    this.status = PostStatus.initial,
    this.categoriesMessage = '',
    this.message = '',
    CategoriesNewsModel? climateNewsModel,
    CategoriesNewsModel? agricultureNewsModel,
    CategoriesNewsModel? environmentNewsModel,
  })  : climateNewsList = climateNewsModel ?? CategoriesNewsModel(),
        agricultureNewsList = agricultureNewsModel ?? CategoriesNewsModel(),
        environmentNewsList = environmentNewsModel ?? CategoriesNewsModel();

  final PostStatus status;
  final String message;
  final String categoriesMessage;
  final CategoriesNewsModel? climateNewsList;
  final CategoriesNewsModel? agricultureNewsList;
  final CategoriesNewsModel? environmentNewsList;

  PostState copyWith({
    PostStatus? status,
    String? message,
    CategoriesNewsModel? climateNewsModel,
    CategoriesNewsModel? agricultureNewsModel,
    CategoriesNewsModel? environmentNewsModel,
    String? categoriesMessage,
  }) {
    return PostState(
      status: status ?? this.status,
      message: message ?? this.message,
      categoriesMessage: message ?? this.categoriesMessage,
      climateNewsModel: climateNewsModel ?? climateNewsList,
      agricultureNewsModel: agricultureNewsModel ?? agricultureNewsList,
      environmentNewsModel: environmentNewsModel ?? environmentNewsList,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $message,}''';
  }

  @override
  List<Object?> get props => [status, message, identityHashCode(this)];
}
