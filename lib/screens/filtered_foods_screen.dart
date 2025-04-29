import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/food_viewmodel.dart';
import '../models/food.dart';
import 'food_detail_screen.dart';

class FilteredFoodsScreen extends StatelessWidget {
  const FilteredFoodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error.isNotEmpty) {
          return Center(child: Text(viewModel.error));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Filtrelenen Yemekler'),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: viewModel.filteredFoods.length,
            itemBuilder: (context, index) {
              final food = viewModel.filteredFoods[index];
              return _buildFoodCard(context, food, viewModel);
            },
          ),
        );
      },
    );
  }

  Widget _buildFoodCard(
      BuildContext context, Food food, FoodViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          viewModel.selectFood(food);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(food: food),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (food.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  food.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, size: 50),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${food.preparationTime} dakika',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${food.calories} kcal',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
