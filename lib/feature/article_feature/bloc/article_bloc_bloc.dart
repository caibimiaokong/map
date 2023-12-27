import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import 'package:wheatmap/feature/article_feature/package.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:wheatmap/feature/article_feature/respository/repository.dart';

part 'article_bloc_event.dart';
part 'article_bloc_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository postRepository = PostRepository();
  PostBloc() : super(PostState()) {
    on<UpdatePost>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PostFetchedAll>(
      _onPostFetchedAll,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onPostFetched(
    UpdatePost event,
    Emitter<PostState> emit,
  ) async {
    try {
      if (state.status == PostStatus.initial) {
        final posts = await postRepository.fetchCategoriesNews(event.index);
        switch (event.index) {
          case 0:
            emit(
              state.copyWith(
                status: PostStatus.success,
                climateNewsModel: posts,
              ),
            );
            break;
          case 1:
            emit(
              state.copyWith(
                status: PostStatus.success,
                agricultureNewsModel: posts,
              ),
            );
            break;
          case 2:
            emit(
              state.copyWith(
                status: PostStatus.success,
                environmentNewsModel: posts,
              ),
            );
            break;
        }
      }
      final posts = await postRepository.fetchCategoriesNews(event.index);
      switch (event.index) {
        case 0:
          emit(
            state.copyWith(
              status: PostStatus.success,
              climateNewsModel: posts,
            ),
          );
          break;
        case 1:
          emit(
            state.copyWith(
              status: PostStatus.success,
              agricultureNewsModel: posts,
            ),
          );
          break;
        case 2:
          emit(
            state.copyWith(
              status: PostStatus.success,
              environmentNewsModel: posts,
            ),
          );
          break;
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostFetchedAll(
    PostFetchedAll event,
    Emitter<PostState> emit,
  ) async {
    try {
      final climatePosts = await postRepository.fetchCategoriesNews(0);
      final agriculturePosts = await postRepository.fetchCategoriesNews(1);
      final environmentPosts = await postRepository.fetchCategoriesNews(2);
      emit(
        state.copyWith(
          status: PostStatus.success,
          climateNewsModel: climatePosts,
          agricultureNewsModel: agriculturePosts,
          environmentNewsModel: environmentPosts,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
