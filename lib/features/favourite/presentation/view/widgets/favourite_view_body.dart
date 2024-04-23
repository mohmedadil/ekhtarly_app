import 'package:ekhtarly_app/features/favourite/manger/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:ekhtarly_app/features/favourite/manger/add_favourite_cubit/add_favourite_state.dart';
import 'package:ekhtarly_app/features/favourite/presentation/view/widgets/favourite_grid_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddFavouriteCubit, AddFavouriteState>(
        builder: (context, state) {
      if (state is AddFavouritFailure) {
        return Center(child: Text(state.errorMessage));
      } else if (state is AddFavouritSuccess) {
        return state.favourite.favoriteList == null
            ? const Center(
                child: Text('There are no items in your favorites'),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: GridView.builder(
                  itemCount: state.favourite.favoriteList?.length ?? 0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: MediaQuery.of(context).size.height * .27,
                  ),
                  itemBuilder: (context, index) => FavouriteGridViewItem(
                      laptops: state.favourite.favoriteList![index]),
                ),
              );
      } else {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
