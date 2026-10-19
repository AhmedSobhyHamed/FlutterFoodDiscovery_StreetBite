import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/add_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/get_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/remove_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_status.dart';

class FavCubit extends Cubit<favStatus> {
  FavCubit(this._getFav, this._addFav, this._removeFav) : super(const favStatusIdle());

  final GetFavUsecase _getFav;
  final AddFavUsecase _addFav;
  final RemoveFavUsecase _removeFav;
  Future<void> _pending = Future<void>.value();

  Future<void> load() {
    return _run(() async {
      emit(const favStatusLoading());
      final result = await _getFav.call(const GetFavParams());
      _emit(result);
    });
  }

  Future<void> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) {
    return _run(() async {
      final result = await _addFav.call(
        AddFavParams(id: id, name: name, thumb: thumb, place: place),
      );
      _emit(result);
    });
  }

  Future<void> remove(String id) {
    return _run(() async {
      final result = await _removeFav.call(RemoveFavParams(id: id));
      _emit(result);
    });
  }

  Future<void> _run(Future<void> Function() action) {
    final run = _pending.then((_) => action());
    _pending = run.then<void>((_) {}, onError: (Object _) {});
    return run;
  }

  void _emit(Either<List<FavItemEntity>, AppException> result) {
    if (isClosed) return;
    result.fold((items) => emit(favStatusLoaded(items: items)), (error) {
      final current = state;
      if (current is favStatusLoaded) {
        emit(favStatusLoaded(items: current.items, message: error.message));
        return;
      }
      emit(favStatusError(message: error.message));
    });
  }
}
